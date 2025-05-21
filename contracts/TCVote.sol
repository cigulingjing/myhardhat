// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TCVote {
    //   加密选票聚合结果（C1,C2)
     bytes public ballot_res;

    //   份额聚合结果 C2
    bytes public share_res;

    address codeStoraddress=0x0000000000000000000000000000000000000043;
    string callFunc = "callFunc(string,bytes)";
    bytes public g;
    bytes public pk;


    function castBallot(
        bytes memory ballot,
        bytes memory ballotZKP
    ) public returns (bool) {
        string memory verifyBallotFuncName = "VerifyBallotZKPContract";
        bytes memory input = abi.encode(ballot, ballotZKP, g, pk);
        (bool success, bytes memory output) = codeStoraddress.call(
            abi.encodeWithSignature(callFunc, verifyBallotFuncName, input)
        );
        require(success, "low level call error");
        bool result = abi.decode(output, (bool));
        require(result, "verify ballot zkp failed");
        string memory aggregateBallotFuncName = "aggregateBallotContract";
        input = abi.encode(share_res, ballot, uint64(5), g);
        (success, output) = codeStoraddress.call(
            abi.encodeWithSignature(callFunc, aggregateBallotFuncName, input)
        );
        require(success, "low level call error");
        ballot_res = abi.decode(output, (bytes));
        return result;
    }

    function submitDecryptionShare(
        bytes memory share
    ) public {
        string memory aggregateShareFuncName = "aggregateShareContract";
        bytes memory input = abi.encode(share_res, share, g);
       (bool success, bytes memory output)  = codeStoraddress.call(
            abi.encodeWithSignature(callFunc, aggregateShareFuncName, input)
        );
        require(success, "low level call error");
        share_res = abi.decode(output, (bytes));
    }
}