pragma solidity 0.8.7;
// SPDX-License-Identifier: MIT

contract Emommarce {
    struct product {
        string title;
        string desc;
        address payable seller;
        uint productId;
        uint price;
        address buyer;
        bool delivered;
    }
    uint counter = 1;
    product[] public products;
    event registered(string title, uint productId, address seller);
    event bought(uint productId, address buyer);
    event delivered(uint productId);

    function registerProduct(string memory _title, string memory _desc, uint _price) public {
        require(_price> 0, "Price should be greater than zero");
        product memory newProduct;
        newProduct.title = _title;
        newProduct.desc = _desc;
        newProduct.seller = payable(msg.sender);
        newProduct.price = _price*10**18;
        newProduct.productId = counter;
        products.push(newProduct);
        counter++;
        emit registered(_title, newProduct.productId, msg.sender);
    }
    function buy(uint _productId) public payable {
        require(products[_productId-1].price == msg.value, "Please pay the exact price");
        require(products[_productId-1].seller != msg.sender, "seller can not be the buyer");
        products[_productId-1].buyer = msg.sender;
        emit bought(_productId, msg.sender);
    }
    function delivery(uint _productId) public {
        require(products[_productId-1].buyer == msg.sender, "Only buyer can confirm it");
        products[_productId-1].delivered = true;
        products[_productId-1].seller.transfer(products[_productId-1].price);
        emit delivered(_productId);
    }

}