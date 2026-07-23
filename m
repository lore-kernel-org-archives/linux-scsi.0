Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E99459AEF;
	Thu, 23 Jul 2026 11:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784804721; cv=fail; b=LZTsOzoAPH9rTAFxbo4LB02cp6vggCDMB76Rq3DU++9cQBvFv7y94Gst4PUWEWhDW/Nx6//B8oAg1eMynsmWQuIRe23OIN83NJUYvkdpiEf0if9VCfZ8fNsK/RW/Z5xjf9SbAckflJb5WsryL9anxPybctlXZCb69Dm7Fn/Mbic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784804721; c=relaxed/simple;
	bh=6QBsPCnwqtTBusZ/jOMbzxDirxljrTpTvP6r9Y+q6l0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I1OAXoXxoz4T+nceMQZypVvwyNt7zWbyZ5AZqbW9qzbPTpfXVn3xNGVIZB7/6PFhYeJupLAHgwJId6nDRFPdi+TdiHcyTpBOmbXzt7p+e3a/2MFdq3gDhowRNIB1KbfmwOVSzELQfAgk+ANOzWGzcakI58yY6mwW0uM+XDUmoQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VLCvWqPF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=g1KzbiIX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VLCvWqPF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="g1KzbiIX"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N2ibI24064752;
	Thu, 23 Jul 2026 11:05:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YnbSklL0GGVxvs678O5XXSRLI37GtRT2d3FMqt5UocQ=; b=
	VLCvWqPFx78T1MTszdF/iuM8k8o03PdIKNln2rxTeOzI7TNwDTs87OGWj57z/FXo
	VxyBfe3f9u3y22iof4KusO6SF+/Kn5ZJVoRjrvP794y5boN2Ai3iac1NEFgyWJKR
	0aMYuvB6IAYA1dVm75YClh4LY6CCKs4ZAAV/UcXEyscHgkHMQFgYVhwlH47e0Y2B
	rYU156qbYqL22OFRctVwFGAfneeAxZOJHrzqWMw91dpg0RvCtD18isVaDOge6Bod
	LyepEDJRIeBu2hSiZhVFnUu2BMyRhXMMcpFhJmJZtJgfcbMHQ8yuS1rtkfeiN4Hd
	odZk4fqeThpgdvhA9NXVzA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1mv6r9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 11:05:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66NB3aWl028499;
	Thu, 23 Jul 2026 11:05:17 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010056.outbound.protection.outlook.com [52.101.61.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxs82ts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 23 Jul 2026 11:05:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I8FBxzIYG+90oUD2w93OYfdxIM3DWB6AO64pgRlBkN4W0vlf2caDHLQsizgMuzw9WAiAP7trSHALP9Znj6ydE9GIZF8o/2VHA0c7S6M1bXqIAQSz7qZ6S4Dha8k3EO7Pu07VSUzKLr7e/F1Rwae7gTrVJ7N3I/4+f06eRoUBNfUKsN9/RYJFFuazIQy6GYqKQaoqzc22NpEhWSWA8+ZGf8lhAumUWgNqsbKh2o/Dc5NHerO2VTqxd7S5ul2CdsL2lktfv+MGYeaLjI4TEy2sunE+oCK1NaBzbOxWt6pL8PZZ+fKQP3Li48uGchQylictrF21y/rpERZaGoWNwqSFow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YnbSklL0GGVxvs678O5XXSRLI37GtRT2d3FMqt5UocQ=;
 b=UXRFoOJkzbWAL/OkBJCkch2zfKeCnKxweuzRFeb7AcljEn/FcTCNhwtYcNTnhswy0cWOQ0s44q0QshygPJAA/SPOEM+TG7SqO/Da0/3SCeAvFYypi4ua8e4odkW8WyKAS/BKEElCrXdNByTIj4nQIgoXLq4bdozdvdk4SojdcCaNhT5NRvb8aQh1RScKWRq2weF37u3ZtmMvfonfqYCg8Dm8ZF/JE+zBNcJrrYvJskgr3CbT+VtL/lThpwwb8qZywR5DH9Lyif4yVKAaRR8AoC1osQ/Ol0s9YdC6mGGdVMqIHZY5d+5nNUFemx6A1VPV9uHSoUESfkyOqhjo+xW7jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnbSklL0GGVxvs678O5XXSRLI37GtRT2d3FMqt5UocQ=;
 b=g1KzbiIXqlMKdzwsxEMPus9mA2wE2+gGLZPks9J86qsUJLH0fBtO52NYIUC227BIcz5VhuCkhxT1ficS1QY9XX8PB6apcZTC9rQoeTl6RqgmmYKw6zZ4bnAjIPe3Fn5ClFtwLx3kn7Kvuk2VPDsg+Urb1vyNBKdduGz/7j/3dK0=
Received: from PH7PR10MB6228.namprd10.prod.outlook.com (2603:10b6:510:213::11)
 by SJ0PR10MB4703.namprd10.prod.outlook.com (2603:10b6:a03:2d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 11:05:14 +0000
Received: from PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d]) by PH7PR10MB6228.namprd10.prod.outlook.com
 ([fe80::11a9:2dfe:4a4a:a58d%4]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 11:05:14 +0000
Message-ID: <e38a2d89-a8aa-4a9c-b41d-ffed99d854b7@oracle.com>
Date: Thu, 23 Jul 2026 12:05:10 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 20/28] scsi-multipath: provide callbacks for path state
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-21-john.g.garry@oracle.com>
 <20260723103626.73BBF1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260723103626.73BBF1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0154.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::7) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR10MB6228:EE_|SJ0PR10MB4703:EE_
X-MS-Office365-Filtering-Correlation-Id: d00717ac-f065-49b1-95d7-08dee8aa4541
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|10067099003|4143699003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oPbQYIbm+Mg55pBBe+9mWz/u38Zvn2S2pLVfNRzuLqC4nGYphOJTOReC0sCziPZWex78gcn+bH6qwlMXs3Mq1AybVnsff9o04g7Jrex1EquTtprzDCCDCWCJAT+fl2bmkO006HsOR0QxMff8fD4ugMgWtqPHHIRZdbGKF6mCvAHM/xS4UZcnNeXvFzlIDsDSmVvGSDgztc6uaBhmqk0YuFz7Ct7+lPcRSQN3bbVB6Ly5Ww0T04N0L5Hrk0A71v9qO1S6Q1XN8+rfYpWX+seIc7VBMXmck0+RopgOR52+7MRnD3Rp5FYHcV+gy/pM8Y6CFxkAwaVqzLH+C8eeEfqNVnFgEUxbABzY4JOn8EAVsI1YfVPQzHBYOG7kTweqxcLcj2GxfNZ5lzhNKYXr/W3iMr8fAK4uVRQQLXN7I/pnSBO5Hqu65BnPcPeVLeRL62bkRP+2+TtCwYiSQuAZAw62fQUTB7mSnDsH7nnG003dEwdPYq7J6BKMA4ybJvmTHWPLWjHjha2ouexHmyHJgZXpzDGbdQkeTC2fXDgc36FwRDcEhAOFx9H35t1B1YvpYDJFhxHYo0Fdc16rMpGRGNLY9hBij0s1AcPhuDg/7uh+/7YZ1WyQxmXjIWtuQmKK+twnAn0XVc3qH0soDkqAyR+sVThp/6qItzvkecXUsBdaL/E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR10MB6228.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(10067099003)(4143699003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c1hjNHE3eHZVamhzS05vZkZEUGNUZEkrbUJzV0lFRU96RENSZThoZHZiQWpE?=
 =?utf-8?B?OW1lb0pwOGJoRE11M0VWQlQ4OGUyM2Yzd3lpWFoyMXBvY3hCL3pUZ2NnUjg0?=
 =?utf-8?B?VUFXR2pUK3RvMThETUxKS0tvSGJJUWExVjI0MUpCT251NG5TUEFETXVMWUxC?=
 =?utf-8?B?Y3dLTUhJdFNCcm5yMlh4M3Z4NHZSNExDeUNFeGdBSGV6VDIvQjhlZW5JZFJP?=
 =?utf-8?B?dEhDS0tBYVQyOEtyVURaWUUxWERYdWxHQU5MbjFMTXpYVkRMQjROLzZTMkY4?=
 =?utf-8?B?KzVaQm41WUd2d1F4SzJ4TmQ4N2h2cWZQUldqcG5HR1VjL1loY1VmaWpLR1V6?=
 =?utf-8?B?dUtNVndCcWxSZmpBL0JaQ0k1ZWNNZnBuRW1yVm5UWDNuWEpqNjRaWTFkRXhL?=
 =?utf-8?B?aWxRVXJSQm90NWcvWjVKMnVOc210WWY5WEkyMzdsRzNKTG5peENCOUtjNWNM?=
 =?utf-8?B?blRJWlFWaGNWS0VCQjJRWmpLcUFRanh6T1U5VWVRTTk2QytITlNqZHpyU29m?=
 =?utf-8?B?VXV0ZmQzV0VkQ1loaWlMbUZpN0tQdndJaGZFV2QxM3I0TTFMWVNsRy9NMnhn?=
 =?utf-8?B?TlRjd2ptTDd6YzZ2WDFhc2Y0SmtHM1NBZTZuQi9HeVpabDRGMzRnemlva1N0?=
 =?utf-8?B?VkV5WjFwRWFXUlBWNnFOM2FQeGduUVJyWCs1QWJ6TDhOUFM1YmF2ZkNTZkpM?=
 =?utf-8?B?d3c4REtXWG02cFpnTnpXTExBRGx1WjQ0Rzhob0dqMHIzSWtIYndRVnAzNEhn?=
 =?utf-8?B?TGpxT0tQaTlCTkF2N1lqT1FBTXMrNkhYaGl0VThxYkNJQ2pmUy8xQjJ5Sllk?=
 =?utf-8?B?RGJWc0Jsa2ZoeHZ6ZWMyYlJjK0JZaE9yWmdMbDErTzY2bCs5KzdqMUlRWU9y?=
 =?utf-8?B?Lzk3YWQzUUJMVjlHWUdIWUhYcDR6RFhwVVZMeUVwMkNiTHB0UzMwbmcvd2to?=
 =?utf-8?B?bU05c3dDOVVUMzVvZDdpaWhFQmtld1l3QjUvM2Jza0NLRGpTZW5xdHlDV3RM?=
 =?utf-8?B?V21nT1ArOWFvaDk4ajRURzFYaE9iUkd0b1pDR3Y4bWpscFRNdUVPK0h4WTA1?=
 =?utf-8?B?VEd0bEIyQW1JamxGbVZKVVpwT2x6V2ZkYXBDd0JZNlpBR2llZWNpMDUrMDg4?=
 =?utf-8?B?alZUYnJHeUQ5MVYzZnhlY1VQcFZsbDltaTM0ZThRbjB4MXhXZUpYNGpXTFp0?=
 =?utf-8?B?ZlRGOElWN0d3ZUZuZ1ZaMW1qK3RXLzROVHMwRHdqaXNnakVzU2JqNkttclFE?=
 =?utf-8?B?azhCbXd2dWJlSnZEcEFQTFc1V2dWSDQ1UEN6TFdtRVIrSmlVNVdKZ000Qmlm?=
 =?utf-8?B?U1ArN1F5SlB5c1RzZzdkWlBMRm8wMVp1TTd5Wm9KUC9NaXlyZWJsTm1iVlR0?=
 =?utf-8?B?Y05xVVR6ZXlTSW1sSFVTSjNmMStOSnZJUmNxUnpjRTJlaUpBN1d4N3BNRHVY?=
 =?utf-8?B?WXRoaWYrQ2ZFRkxXMG4vczRIaFdEN2dGSnhGL3JsUFBHZk9ZOFJqSG83V3Ex?=
 =?utf-8?B?Ti9VSW90Ykw1TWtyNllDdDRlRjhjWEM4WmNpVzN6OXh1NWhaRng3TzcwV1hm?=
 =?utf-8?B?OXYwcWlpYSttNW9welR1Q09MNW9UdVdKYmovam56TnoreTQ4SVVxSUp4Ty9l?=
 =?utf-8?B?cGg5cXY0R3U3T05mQU5ndE5sZDdFNjFUcytMRzBmNFhORGJDVkpGRTRseld0?=
 =?utf-8?B?SGJpdWRFNHdVYUVpK2I4VTFhb2pkb1BKalA0NzVlTHB2SHFqVUVaSFZneFgz?=
 =?utf-8?B?QkxmSmRCd2N3S1J5MWpmOVRBZFh2RW1KZ2tUcTZ2VWZ2MjRWamt3eFdRRDVn?=
 =?utf-8?B?NlJsdGEwODBMVEgvaVZsaDZmZW91REt0WTFlT0cyZVoySG5QY3BmRVRLMURa?=
 =?utf-8?B?TytSKzgvTHM3WnBnYit5RllkL2ZDUyszU2lJTTd3UXNod0lzMFRQUHlaVUEv?=
 =?utf-8?B?Unl4ZGVGMzFaejRDMEFuYzhnd094bkFyWFpkZ0tZdENZSDFySE4zN1VUc2Uv?=
 =?utf-8?B?dWhtOURTQjA3R081TXlZeEF6OHViS1ZsTXpnd1lTNDN0dVNHaFFxUndmSXR2?=
 =?utf-8?B?aUwrTSt6OUE1Z0Mwc3BZTWsrd0M5QjRXV2lOMTJDYjN4a3F4RzRIN0g0UnhM?=
 =?utf-8?B?TXJXZnNZR3ZBemdCWXZaazA2UjY4cWwxWlhJR0FLbjNTWnZ2Y2RkQ0FyZG84?=
 =?utf-8?B?Sit1SEJlSnRIUkVRYkdmK0FRWHVzaUkyTzNmMjNLY1NxdE9QL3VjSTRnbFpj?=
 =?utf-8?B?azc3bXN4Z29ZWGZESW0ybDVtRzdCVWdwa21ZQzJhdXhBSUhZRzhVaUFjSDdG?=
 =?utf-8?B?aUM2ZEdHVHkwbnp4VGJGbFhwdThjbXRRWkYzQ21Mb1F3SGhpZTZYY2N5Y215?=
 =?utf-8?Q?FegMMb2H3TxZtTdg=3D?=
X-Exchange-RoutingPolicyChecked:
	itWqlQiU1fP/JCrNsWd9gNSlQ6jNLiYOlwKZ2j1rwqvkcv8lKjznx/dmFGgBdakngWNNwRUEuFHpdOI9Wva0aXpZMDfGcj0s1teCtugx9Oi7WRoL+ZPmWTeNcTE0S5a36iW4j15jkOO62QUq/1KN7ihBb5gmD31XW0/960lkgplxbSnSJy4r08ZszwUShx3QkNTMZ/5h4DxzU+xnJdovae2CU8L++ULuaZWZUzoVmDhZ8TqbfVtX1NpbtVIpdpHQQwsHyZqkcnK7YQMjERcHcLnJc94A2G6S6g+P6KAXebIEnA1FbDTm8Np+rU0VsdxRMZKxme0NFH+6KIsla9zVgQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	irkYzQqr4JqKisoxOI9qJGNqInr8FK3kjY5QmHGPCdLnraTOahaDJfKGMDM1qH/3NHkIwTna0UUxq2CtiKDQiVKwNLbTyObeLXFJoafwKA+ga0gpeerN+Q+CWVmmEybzCMgDvZWUyQ8fHJ/u84V+jMRgmoQgntuk5ixwoeBI8tWEqC4Uuq5JSrjpuzI+voEQxIwoIqvR87ysXrVO64iqZtUlcCw7ejUC5lVjHSzNkOxQU5TqIwQdNi9lEPPBgvn6JMvRc+iA9N+neIT+4Ai8hqaePqt1wb3rpmHJVw8lx3HhhwkW74HCADCyijm0XIQCi1/wbyvrznhIkHNJcfrAnKeX7vLHJnM63QL6Sbqgs+gQ/LhhLYwm+Ti7RCjZrCzMDWfHxbwkxuYeSoxOOqEbR8hZJfX3N7Q40byqHPAbJcrB8qYRqGc4xwKgy7GV5txBCAQyNd2j73LARnb6DtuCNsLMGBm+HFOwRNvz7qEZC7Q+lvv+OaYUwsuRx/4HS9KvHdGLcirN0BV8vySqBO771vM2+Eb7X1pzjewJ47RfVN7luep5uKNcvVax+Ev1rtbZ1khQVkYoEVeXxWPgv9q8jPQhZaUjcEraIBhIc6dsZ8w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d00717ac-f065-49b1-95d7-08dee8aa4541
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 11:05:14.3810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4b5II3YVHa0fWKaytVX+vduGDEom7GqeRxQTyevKEa0qD102xkSkJevJVGNJNHAzFn0JbKLhiR7+KKkYjDmG4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4703
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607230109
X-Proofpoint-GUID: ItSJLYvgy4k_ApTNV0lThVMQwWd4ySPu
X-Proofpoint-ORIG-GUID: ItSJLYvgy4k_ApTNV0lThVMQwWd4ySPu
X-Authority-Analysis: v=2.4 cv=IsYutr/g c=1 sm=1 tr=0 ts=6a61f56e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=sMlFW2VQs2M9JnoeAaUA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13523
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEwOSBTYWx0ZWRfX6gJNTzy+1sYi
 CzHcr5udSYIBUTKm7/UHN0NjI4lZCO4Zvejh3O2QaaNyUYmymq8zFUOT32RyP0iw1KnJ1n6Wvc3
 N6TAkwuolKZ1H3515timKgTGstr1sTr9z16W/qZsmIwN80rkyq0r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEwOSBTYWx0ZWRfX8j50CFUMzB3O
 +LOnvrdeNt7wj9dgNP5T0V73/5TldCBY+eE6whZskJ55b6jykNpY2sRkE0PWLuzhcoym/C4/w7H
 i/8MFD9WsYMewC7vucPuezLbyM9eUNnA75UJ6T1j4xZhTTfXGKBiGjYlIs/ZLfBsRxUBvUQGOF/
 yT8etR3kJ/31Ozjx3qwVV2pr/PXXop+Gcj9ZTcTsJtrH5Jx2D0UixMkVB0sXWXix1SEEZ7QWiZQ
 HWu4ffV+2Buv8LBJ9bDxFYcF82vC9Z9qIiN5GrFa1UQW4ogu4HcK/z4ud8+1kRWGjpifg9JpHIr
 bDPPGClOOp2JVDsZn2LR9q50+07dn1wuZVP673fnJA4BPlonzcJO1d+R1mPtn6X5qGLf5eK1c48
 RXuJw3fdI3k1zWV3JeW6LSu7rqv1egAyai/6iTtN4Dl9uCFKjQ+7fmxWYCLPm3LJnLuw+C7TuaZ
 9BMbRMgSRAeUXstdNcrFtRf7Kr9iNYzNs7ig1x/k=

On 23/07/2026 11:36, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] ALUA access state is not synchronized with the core multipath library, causing path selection to incorrectly treat non-optimized paths as optimal and resulting in an infinite path re-evaluation loop.
> - [High] Missing ALUA path activation and state change notifications cause indefinite I/O hangs when only STANDBY, TRANSITIONING, or LBA-dependent paths are available.
> - [Medium] Missing READ_ONCE() on concurrent sdev->sdev_state access can cause TOCTOU vulnerabilities via compiler reloads.
> --
> 
> --- Patch [20]: [PATCH v4 20/28] scsi-multipath: provide callbacks for path state ---
> commit 0d49283b5a1edcf6983ec33d9d54dad0023fe90c
> Author: John Garry <john.g.garry@oracle.com>
> 
> scsi-multipath: provide callbacks for path state
> 
> This commit provides callbacks for .is_disabled, .is_optimized, and
> .available_path. These all use scsi_device.sdev_state and
> scsi_device.access_state, which will be driven by ALUA.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index a482b6ede21aa..e566d47199fcc 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -316,7 +316,56 @@ static struct bio *scsi_mpath_clone_bio(struct bio *bio)
>>   	return clone;
>>   }
>>   
>> +static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
>> +{
>> +	struct scsi_mpath_device *scsi_mpath_dev =
>> +				to_scsi_mpath_device(mpath_device);
>> +	struct scsi_device *sdev = scsi_mpath_dev->sdev;
>> +	unsigned char access_state = READ_ONCE(sdev->access_state) &
>> +					SCSI_ACCESS_STATE_MASK;
>> +
>> +	if (sdev->sdev_state != SDEV_RUNNING)
>> +		return true;
> 
> [Severity: Medium]
> Should sdev->sdev_state be read with READ_ONCE() here to avoid compiler
> reloads, similar to how access_state is read above

will fix

> 
>> +
>> +	if (access_state == SCSI_ACCESS_STATE_OPTIMAL ||
>> +	    access_state == SCSI_ACCESS_STATE_ACTIVE)
>> +		return false;
>> +
>> +	return true;
> 
> [Severity: High]
> If a path is in ALUA STANDBY or TRANSITIONING state, it is treated as disabled
> and skipped during path selection.

alua support needs to be improved later

> 
> When all paths are in these states, scsi_mpath_available_path() will return
> true since the state is SDEV_RUNNING, causing the block layer to requeue the
> I/O.
> 
> Does this logic ever call scsi_dh_activate() or trigger an implicit ALUA
> activation to transition these standby paths to optimal? Could this result in
> an indefinite I/O hang with the requeue list looping forever?
> 
>> +}
>> +
>> +static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
>> +{
>> +	struct scsi_mpath_device *scsi_mpath_dev =
>> +				to_scsi_mpath_device(mpath_device);
>> +	struct scsi_device *sdev = scsi_mpath_dev->sdev;
>> +	unsigned char access_state = READ_ONCE(sdev->access_state) &
>> +					SCSI_ACCESS_STATE_MASK;
>> +
>> +	if (sdev->sdev_state != SDEV_RUNNING)
>> +		return false;
> 
> [Severity: Medium]
> Should this unlocked read of sdev->sdev_state also use READ_ONCE()?

as above

> 
>> +
>> +	return access_state == SCSI_ACCESS_STATE_OPTIMAL;
> 
> [Severity: High]
> Does this dynamic check of the ALUA state conflict with the statically
> initialized access state in the core multipath library?
> 
> If an I/O is submitted to an ALUA Active/Non-Optimized path, won't the core
> reject the cached path, fall back to __mpath_find_path() which uses the
> static state, and continuously re-cache the exact same path? Could this
> result in a perpetual cache miss and an infinite path re-evaluation loop on
> every submission?

as above for ALUA

> 
>> +}
>> +
>> +static bool scsi_mpath_available_path(struct mpath_device *mpath_device)
>> +{
>> +	struct scsi_mpath_device *scsi_mpath_dev =
>> +				to_scsi_mpath_device(mpath_device);
>> +	struct scsi_device *sdev = scsi_mpath_dev->sdev;
>> +	enum scsi_device_state sdev_state = sdev->sdev_state;
>> +
>> +	if (sdev_state == SDEV_RUNNING || sdev_state == SDEV_QUIESCE ||
>> +	    sdev_state == SDEV_BLOCK || sdev_state == SDEV_CREATED_BLOCK)
>> +		return true;
> 
> [Severity: Medium]
> Since sdev_state is a local variable assigned via a plain read, can the
> compiler reload it from memory for each condition in the if statement?
> 
> If the state changes concurrently between SDEV_BLOCK and SDEV_RUNNING, could
> all checks evaluate to false even if the state is always one of the valid
> values? Should this use READ_ONCE()?

as above

> 
>> +
>> +	return false;
>> +}
> 
> [ ... ]
> 

