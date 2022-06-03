// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// NFT contract to inherit from
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions Openeppelin provides
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./libraries/Base64.sol";

import "hardhat/console.sol";

// Inheriting from ERC721, which is std. NFT contract
contract MyEpicGame is ERC721 {
    // hold our character attributes in a struct
    struct CharacterAttributes {
        uint256 characterIndex;
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }

    // For tokenId
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // A lil array to help us hold the default data for our characters.
    // This will be helpful when we mint new characters and need to know
    CharacterAttributes[] defaultCharacters;

    // A mapping from NFT's tokenId => that NFT's attributes
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

    // A mapping from an address => the NFTs tokenId. Gives us an easy way
    // to store the owner of the NFT and reference it later
    mapping(address => uint256) public nftHolders;

    struct BigBoss {
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }
    BigBoss public bigBoss; // var to hold our boss so that we can reference it in different functions

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint[] memory characterHp,
        uint[] memory characterAttackDmg,
        string memory bossName,
        string memory bossImageURI,
        uint bossHp,
        uint bossAttackDamage
    ) 
        ERC721("Heroes", "HERO")
    {   
        // Initialize the boss. Save it to our global bigBoss var
        bigBoss = BigBoss({
            name : bossName,
            imageURI : bossImageURI,
            hp : bossHp,
            maxHp : bossHp,
            attackDamage : bossAttackDamage
        });

        console.log("Done initializing boss %s with HP %s, img %s", bigBoss.name, bigBoss.hp, bigBoss.imageURI);
        
        // Loop through all the characters, and save their values in our contract so
        // we can use them later when we mint our NFTs.
        for (uint i = 0; i < characterNames.length; i += 1) {
            defaultCharacters.push(CharacterAttributes({
                characterIndex : i,
                name : characterNames[i],
                imageURI : characterImageURIs[i],
                hp : characterHp[i],
                maxHp : characterHp[i],
                attackDamage : characterAttackDmg[i]
            }));

            CharacterAttributes memory c = defaultCharacters[i];
            console.log("Done initializing %s with HP %s, img %s", c.name, c.hp, c.imageURI);
        }

        // Increment _tokenIds here so that my first NFT has an ID of 1
        _tokenIds.increment();
    }
    // Users would be able to hit this function and get their NFT based on the
    // characterId they send in!
    function mintCharacterNFT(uint _characterIndex) external {
        // Get the current tokenId
        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId); // inbuilt fxn

        // Map the tokenId => their character attributes
        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex : _characterIndex,
            name : defaultCharacters[_characterIndex].name,
            imageURI : defaultCharacters[_characterIndex].imageURI,
            hp : defaultCharacters[_characterIndex].hp,
            maxHp : defaultCharacters[_characterIndex].maxHp,
            attackDamage : defaultCharacters[_characterIndex].attackDamage
        });

        console.log("Minted NFT with tokenId %s and characterIndex %s", newItemId, _characterIndex);

        // Way to see who owns which NFT
        nftHolders[msg.sender] = newItemId;

        // Increment the tokenId for the next person that uses it
        _tokenIds.increment();
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];

        string memory strHp = Strings.toString(charAttributes.hp);
        string memory strMaxHp = Strings.toString(charAttributes.maxHp);
        string memory strAttackDamage = Strings.toString(charAttributes.attackDamage);

        string memory json = Base64.encode(
            abi.encodePacked(
            '{"name": "',
            charAttributes.name,
            ' -- NFT #: ',
            Strings.toString(_tokenId),
            '", "description": "This is an NFT that lets people play in the game Metaverse Space Slayer!", "image": "',
            charAttributes.imageURI,
            '", "attributes": [ { "trait_type": "Health Points", "value": ',strHp,', "max_value":',strMaxHp,'}, { "trait_type": "Attack Damage", "value": ',
            strAttackDamage,'} ]}'
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        
        return output;
        }
}