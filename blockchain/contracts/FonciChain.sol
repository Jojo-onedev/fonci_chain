// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract FonciChain {
    address public owner;

    enum ParcelType { NonLoti, Loti }

    struct Transaction {
        bytes32 dataHash;       // hash des donnees off-chain (proprietaire, documents...) - AUCUNE donnee personnelle ici
        uint256 timestamp;
        bytes32 previousTxHash; // 0x0 si c'est le premier enregistrement
    }

    struct Parcel {
        ParcelType parcelType;
        bytes32 currentTxHash;  // pointe vers la derniere transaction (etat actuel)
        bool exists;
    }

    // Recherche par identifiant de parcelle (equivalent du matricule etudiant chez DiploChain)
    mapping(bytes32 => Parcel) public parcels;

    // Recherche par hash de transaction (equivalent de diplomas[])
    mapping(bytes32 => Transaction) public transactions;

    // Historique complet d'une parcelle (equivalent de studentDiplomas[])
    mapping(bytes32 => bytes32[]) private parcelHistory;

    event ParcelRegistered(bytes32 indexed parcelId, bytes32 txHash, bytes32 dataHash, ParcelType parcelType);
    event OwnershipTransferred(bytes32 indexed parcelId, bytes32 txHash, bytes32 dataHash);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the FonciChain admin can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Enregistre une nouvelle parcelle sur la blockchain.
     * Appelee uniquement par l'admin, apres verification hors-chaine des documents
     * (CNIB, titre existant ou accord du chef de village pour le foncier non loti).
     * _dataHash est calcule cote backend - jamais les donnees personnelles elles-memes.
     */
    function registerParcel(
        bytes32 _parcelId,
        bytes32 _dataHash,
        ParcelType _parcelType
    ) public onlyOwner {
        require(!parcels[_parcelId].exists, "This parcel is already registered");

        bytes32 txHash = keccak256(abi.encodePacked(_parcelId, _dataHash, block.timestamp, bytes32(0)));

        transactions[txHash] = Transaction({
            dataHash: _dataHash,
            timestamp: block.timestamp,
            previousTxHash: bytes32(0)
        });

        parcels[_parcelId] = Parcel({
            parcelType: _parcelType,
            currentTxHash: txHash,
            exists: true
        });

        parcelHistory[_parcelId].push(txHash);

        emit ParcelRegistered(_parcelId, txHash, _dataHash, _parcelType);
    }

    /**
     * @dev Enregistre un transfert de propriete (vente, heritage, cession).
     * Appelee uniquement par l'admin, apres verification hors-chaine que le vendeur
     * est bien le proprietaire actuel et que l'acheteur a fourni ses documents.
     */
    function transferOwnership(bytes32 _parcelId, bytes32 _newDataHash) public onlyOwner {
        Parcel storage p = parcels[_parcelId];
        require(p.exists, "Unknown parcel");

        bytes32 previous = p.currentTxHash;
        bytes32 txHash = keccak256(abi.encodePacked(_parcelId, _newDataHash, block.timestamp, previous));

        transactions[txHash] = Transaction({
            dataHash: _newDataHash,
            timestamp: block.timestamp,
            previousTxHash: previous
        });

        p.currentTxHash = txHash;
        parcelHistory[_parcelId].push(txHash);

        emit OwnershipTransferred(_parcelId, txHash, _newDataHash);
    }

    /**
     * @dev Verifie l'etat actuel d'une parcelle. Equivalent de verifyDiploma().
     * Public : n'importe qui peut verifier, sans avoir besoin d'etre admin.
     */
    function verifyParcel(bytes32 _parcelId) public view returns (
        bytes32 txHash,
        bytes32 dataHash,
        uint256 registeredAt,
        ParcelType parcelType
    ) {
        Parcel memory p = parcels[_parcelId];
        require(p.exists, "Parcel not found");
        Transaction memory t = transactions[p.currentTxHash];

        return (p.currentTxHash, t.dataHash, t.timestamp, p.parcelType);
    }

    /**
     * @dev Recupere tout l'historique de transactions d'une parcelle.
     * Equivalent de getStudentDiplomas().
     */
    function getParcelHistory(bytes32 _parcelId) public view returns (bytes32[] memory) {
        return parcelHistory[_parcelId];
    }

    /**
     * @dev Transfere les droits d'administration (ex: changement d'agent responsable).
     */
    function transferAdminRights(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "New owner cannot be the zero address");
        owner = _newOwner;
    }
}
