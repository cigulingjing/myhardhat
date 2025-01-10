// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// contract TCVote {
//     address public commiteeContract;

//     // 加密选票聚合结果（C1,C2)
//     bytes public v1Res;
//     bytes public v2Res;
//     bytes public v3Res;

//     // 份额聚合结果 C2
//     bytes public share1Res;
//     bytes public share2Res;
//     bytes public share3Res;

//     address aggregateContract;
//     address verifyBallotContract;

//     string callFunc = "callFunc(string,bytes)";

//     bytes public g;
//     bytes public pk;

//     function castBallot(
//         bytes memory v1,
//         bytes memory v2,
//         bytes memory v3,
//         bytes memory ballotZKP
//     ) public returns (bool) {
//         string memory verifyBallotFuncName = "VerifyBallotZKP";
//         bytes memory input = abi.encode(v1, v2, v3, ballotZKP, g, pk);
//         (bool success, bytes memory output) = verifyBallotContract.call(
//             abi.encodeWithSignature(callFunc, verifyBallotFuncName, input)
//         );
//         require(success, "low level call error");
//         bool result = abi.decode(output, (bool));
//         require(result, "verify ballot zkp failed");

//         string memory aggregateBallotFuncName = "aggregateBallot";
//         input = abi.encode(v1Res, v2Res, v3Res, v1, v2, v3, g);
//         (success, output) = aggregateContract.call(
//             abi.encodeWithSignature(callFunc, aggregateBallotFuncName, input)
//         );
//         require(success, "low level call error");
//         (v1Res, v2Res, v3Res) = abi.decode(output, (bytes, bytes, bytes));
//         return result;
//     }

//     address verifyDecryptionShareContract;

//     function submitDecryptionShare(
//         bytes memory m1,
//         bytes memory m2,
//         bytes memory m3,
//         bytes memory m1zkp,
//         bytes memory m2zkp,
//         bytes memory m3zkp
//     ) public {
//         string memory verifyDecryptionShareFuncName = "VerifyDecryptionShareZKP";
//         bytes memory input = abi.encode(
//             commiteeContract.getCommiteeId(msg.sender),
//             commiteeContract.getIndexX(),
//             v1Res,
//             v2Res,
//             v3Res,
//             m1,
//             m2,
//             m3,
//             m1zkp,
//             m2zkp,
//             m3zkp,
//             commiteeContract.getCommiteePK(msg.sender),
//             g);
//         (bool success, bytes memory output) = verifyBallotContract.call(
//             abi.encodeWithSignature(callFunc, verifyDecryptionShareFuncName, input)
//         );
//         require(success, "low level call error");
//         bool result = abi.decode(output, (bool));
//         require(result, "verify share zkp failed");

//         string memory aggregateShareFuncName = "aggregateShare";
//         input = abi.encode(share1Res, share2Res, share3Res, m1, m2, m3, g);
//         (success, output) = aggregateContract.call(
//             abi.encodeWithSignature(callFunc, aggregateShareFuncName, input)
//         );
//         require(success, "low level call error");
//         (share1Res, share2Res, share3Res) = abi.decode(output, (bytes, bytes, bytes));
//         return result;
//     }
// }