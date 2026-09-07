Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556484F7970;
	Mon,  7 Sep 2026 14:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788792636; cv=fail; b=RczbJktgEBYaqrSeX9IDuk9+ZocFme22V0Why8UNvCoACed17FylyDi7eHkSpAnxFt+8JH+m/AoS/9RgI1ZMEOOnP0z/t+aDRkK+k4nTSNSnItlWmaDt+BgoqpDZakVvBNAXLiNq5n8t+VYXHuLYcqd1mffgNmabJmytS5/9Xwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788792636; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tozWM2kmIBKt68FXcYLwrKoESmPFCwlnLwiKGg+NZWTWFevLU6ym7qAGHzqnSPzDKBX0+jm7LT84E/GN+ms8G/l+fgUHDrsWE/gwjviMTSVO8aG0MaNA+/2NItzF/lvyqosXUgxDZTxXJeA9Nf+QU4/CfmC1CUH8jl8HcwucC8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bqapaDnO; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=btf5/Ear; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bqapaDnO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="btf5/Ear"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788792630; x=1820328630;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=bqapaDnOhbFH6+cjhl5k66Cf7LNkDaahPwiK5erlMftXiJZIpd/Yva1F
   G54obTd6Kko0BcAELWRyK1nZDMDccQcmIVKymXKeAHb3ZxoCu1YX4NhkC
   MxKlAh9kFVIfWlVjxF4N/qldDke1Uz4Wel2Fr39y2H2auCB1ubhi3l5fu
   D3VBer3q7jy2pzwxnmgqxk/b2/tV4bAOFvZi3pKtBHU/SrbPuNs4GCp2a
   /ppLkpteoKiGejX4J6Lhrt4/sWIa863UoTPYPcS9VUYnDyblAtokVjcG+
   2YLcd+kR8mFlufA67V1idPkHrO7HDvKw3e7qdchsUz+Ba7pSKlheus4AM
   A==;
X-CSE-ConnectionGUID: R5s7e7jzT76A9G3ZQ6Vr2Q==
X-CSE-MsgGUID: jHweDJwrRJ+AEZ85rjYj0Q==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="154166635"
Received: from mail-southcentralusazon11012035.outbound.protection.outlook.com (HELO SN4PR2101CU001.outbound.protection.outlook.com) ([40.93.195.35])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Sep 2026 22:50:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VsDRKWUCaHbIOaErBOlyPe27VOpOmIlc7Gu46kR2ETkwnYMslfCS0+yE32ys82l2czYuFZNxt8zLrTH70j+y9rtihPjR2ZRaq+3U+subkMfncBM5SX55akXUc4wKn5Oc3QVdgtI5QvT53d7D2H7e68M4JToQquAJ4P3CC1GDB5NdEW5Qli1ELFvIBfbdSVz/0lJBcIQjXn8yXefr+McgKafFXwApp06J+RMZSHQ+J+IvFE+Chp5Ltb3RcGrf/7zoDEfdO0jb/lfAAPqHlyRZ0ZUS0yeMB+N5qL0g7O2D8Dm8hhAhOzBlc81LGfAq1Syj0+1IMc+GAzwjSfnqjgqG2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=nTN+BsJFu6IBjBg1FAu3826ZulsO9oNiJGuPRj7om8WAqaXGkdszzvuzSKOCuuBZh+gt18pY1vXPnqlElt3cuYqhzmaPcl//Uz7QOXsTVkD5BOTJGgcy8hnXAr0WX5oNyfubQpVjHH5bVNsM+tCafVhzHGaHkp0mMGPQqUqcNiWVt6k1wKF8n97hC1jbeQVyp9cLmmGDazT+U4MS/9HUfySwKUewCsyZYCGhUqoeK9fdAESY4Lel3Er5eE3LvwO0RVyqK0WL/jSX1eikmle/GVG0bqJDDSeWvy4gPH8/5N/G1TawaUhoDQd7+f2u6TBm4P1CFWFx0g+G0VK2tb3QTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=btf5/EarG8+W439aYRCNUqcaSLgRKC0c+qGeZm9Hr4sTW6DIVTOAasWFJSz2O6ktSRNtOLd+SNxN9S9OCWO2aTtU5s5lY9Xeh2+AtktftnkA29s4c5BkQ9qhS/GhmF1A7T3l6af/DaDni8ew7pWmgkGACpYUSEVBUPZ8QaW/MHU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BY5PR04MB7076.namprd04.prod.outlook.com (2603:10b6:a03:222::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 14:50:16 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 14:50:15 +0000
Message-ID: <622914ef-0138-4620-abce-c185d8ae76de@wdc.com>
Date: Mon, 7 Sep 2026 16:50:11 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 21/40] scsi: megaraid: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-22-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-22-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0441.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c6::10) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BY5PR04MB7076:EE_
X-MS-Office365-Filtering-Correlation-Id: e51265f6-5a79-42ea-ee78-08df0cef540a
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|19092799006|921020|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5deqRS81wBGA+EPsXeSxguRcLE2qLNB1jsRtYZIH0C3zDwE7JtScKY8gYYeE9byaOvMDiFwjIL72mV7HXOiU/DWY6bBC2hyw/xMrygKPAb7hM/MYOj9PRhGkIzxN3hXkj/EYMshPohCiDAR8/xjAKONRASRLycq6ixxKK1o1qjIabK/bGudmOs6KS4DjHey4nixHAAkvCLyrYd0D58iFpYAZ+qeiH9UxPjA87Hf5T/oU61a3CpxyrfEISxR6CY9cxRR/rWzLNZdN/IiYp1WIVLUu8hRaCXvia3gJRkOiwt0n9o9TEYTG/AqV4rnzb+oB+n8rLSgk+3rv7X6DV10Mx8c2BqPTZJnk+aMA/Hm+E+/hlpe23kummxCZMEaX1u2tVRKCnoEYUCg47+AWDA4Hw/e9DizezhTd6vSH/HKp1x8kfvV2kHOypUNlWiCCWZr/pEeOTWORVl6T3PMt0gMHaCZ1dCpKA57/24IzynaAGa0Jie2pehuVwgGx3Bi/kfESNn7l2xs6AqHZiwUwXlJ7TUospp2tzFC6X1dBBv8mn3VQq+nifu8MEpYvVAiFwRMJRh1nBTK4nNdHg+G3HDnb3v1zUID+MfI9f1CacYxtJdJqdJqv/gImxC0elto9B3BzG19SynDKTcTkKOqnK/vf3LfoNFkbr1J7ePTydcgHVN9JFIno9R1M0lh1giQ5ahNP4RVotIajVNQsKqyncFVJIg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(19092799006)(921020)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UldzT2pOdHl4SGVXbWhGVlNvZ3QyMUpsSnhFaDI1WmNFL2R6NmVYd1pHQnNS?=
 =?utf-8?B?dmFuNDB0dEhjUWp2QXVUV0VNenB0RFU1VVI2cytQZnFZV0x0Y0ZLbVZ0dmZI?=
 =?utf-8?B?RFVUVm96NGVpbWNMWTgwVW9NNzR2RjhNSmtrdFpzMWdXNmxEY2dFdGZhclly?=
 =?utf-8?B?bnlNeGk3ZHorZE81NmRFSTRHV2dtcnk3dWR1SkxSUlFyMSsyb1dYakxFRjdv?=
 =?utf-8?B?U1dDUzRWdHdNSm5RQ0dZSGFlM2EwdXlTb3lMdHQ5YzZSTzdFeTBaa1dJOEpn?=
 =?utf-8?B?Sm5acUNhOEQzNWJic3BqSGRRQmU0NHZEZlc1SzZhdTBTbzdNUU9ma1JURGpB?=
 =?utf-8?B?b05MYVRUaGQwVVdiT0w1OUU1K1ExQXgvZUN0eFZDTHdTSkM4cGFvWTY2bUxH?=
 =?utf-8?B?NW02QlRzT0hZek1kbGYrb2tIa2NuK3UrSWc0ZFVHdkYwVWtSTDdFcW1VOXlH?=
 =?utf-8?B?ckpRQUIwYWV3SlBUVzVPWVI1SHMyaVVUZklBL0FoWVM3WmJJcVIwSUtNSStI?=
 =?utf-8?B?WTBsM0FLMmdKSm9vUk9JNmNrRXI0Uzl3c21kWWdtU1hHa2UzOEx5RWhKcEFn?=
 =?utf-8?B?Q0tucUVtb1ZaY0VGOXI3ZE1VZE84RFBnMVFpR2NrWFd4SmRhZE1oOFd5dTZD?=
 =?utf-8?B?NnZJS3ppMysxQUNFenpMSzYvUHVSNUhHOWRqWUxzaE04L0o5ck1OeGo2bmpa?=
 =?utf-8?B?S0ZUMGQ3NElGY1ZhditHZVBpR3AyZ1MxdHl3Z3liQ1BnZDhQTjdCbjllMG1M?=
 =?utf-8?B?c1pLc0Y4RFRZbUNMTEhQTStSMlhIeEJaQWNUM0F5L1ErVVJkMytsNWJGOGxm?=
 =?utf-8?B?SHF4REZ6MHM2clJSMWFycDJEdnJJUEtDYnk3R2JreUlBK3c1YjJMRGpNcmpn?=
 =?utf-8?B?OElWTklUTC9ZM1B4a0FFQWFodjRGUlBhMXRydjBWMGtDeTkwbnNpbGNmdnZa?=
 =?utf-8?B?WUNiSnVlMkE0TjV3UmJLNTVlSWkwTFVEN2t2Y25FNEZZNTZTRjJkMjhUU0lT?=
 =?utf-8?B?MDBnTEIxdWg5TE90RjlNL2VDcHh0WEgwK3pXUlNIWU40TXFRcnFCOEFTTElX?=
 =?utf-8?B?c29iMCtMUTh0WUwyYmRHaytSNFIxdnJtU3M0ZkdEOWhFYXY2eHZHSWpieHBW?=
 =?utf-8?B?alRJdFpqbFpocHovaVowVlNCNXdjQXBBREo3dzFOOTh1bmhNZ2hpSlFHY3dG?=
 =?utf-8?B?Nm94ekkvdGU0eEgrSGR4UXc5aDlGaU9wakdaNWpyS2s5SHQrZVByNE9SMkNn?=
 =?utf-8?B?TUU1UlVJZ3ozcnM1QVdWYmZOb1dLM1dIZ1VLeDlGNGUra3h0OGlReTJlWHFZ?=
 =?utf-8?B?aHdRRmxET2N2QmhvVWMzaEVIQ2o3Y2tTSTlwOEF1YXNGU2FKYzdvRTFXMnJY?=
 =?utf-8?B?UStwdGtVaEU5Z1JFTnRwL3FpRFFhWTl4aURIN25QSEZRZXZZUE1pOHJVa0Uv?=
 =?utf-8?B?LzQxc3dyMjdjYThia2RlUnRrSzlYY1JxOVp1RGdydWV2UExMSXdHK0RXcjRJ?=
 =?utf-8?B?S0E0bVA2SkUzVHJEMVdzMVhXUVNFQklPUXRzM0NVNWxoUE1GZnFScDFYbkxK?=
 =?utf-8?B?TU8weW9jcGV3T3lYdmhxNWJvcVlnNVJqTU12cVZzU2FTUlY5bVpXc295Q0tv?=
 =?utf-8?B?VHk1NE8rSWdtVkFOQktVSnJMSXYwcjloY1NhQTVwcWNWV1crbkVYQW9GaFlQ?=
 =?utf-8?B?N0RuVVAzWTZPb0kvc1RUZTJKOTFTb01COElSQlVudUdwZ01NeVd1OWRhbnVC?=
 =?utf-8?B?Y2pjVVY0S2ZqdDZEWFBQMDg1TWVBTFFxMUxpaU9pTGtJREVnTHovMXpPTDJR?=
 =?utf-8?B?U3k2NlBnNml2V1BXellyWnZQN2pCZFhJM1JzZndVS2JRS21iQUVoNEhGRlNV?=
 =?utf-8?B?QlhhbStKNEk1NDU4ck92bU11TE1lbjFtWGphMDVDeEtzZURGeWpydjJEYUVR?=
 =?utf-8?B?YWRlVU5sb1YyNSsrRDQ5ZWRabTJYaVc5WEk3WDBKd2dDd1hRK2hnSG1JVUl2?=
 =?utf-8?B?Wkd1QmtCRkN2VUpMNFBLRVByL3M0SENqRS84MThrWnZBNEVmL0hzeHAvaitW?=
 =?utf-8?B?dDJQaHo5SDRvV2Foc0FUSjFTNGFYUkZ6WjRDSS9hMWlIWTFCdTRuMkRrRWdl?=
 =?utf-8?B?YVVYVDNXSkYwdWNYdDM0and0TWpJWHpVR0pwbUJhbUxBdkdBMSsrMFNyYllP?=
 =?utf-8?B?V2pWQS9zdnZzdW1PdWsyWE1zVGw3T3p1RVI0b2ZvekxtdHpJbFI0QXdNU1dq?=
 =?utf-8?B?K1BZNldJYU9KTE92cFZaOElOSUsvU2xzNkk3eThXcTdFZVJrNHVTUFM0bG1K?=
 =?utf-8?B?NitDYzM1V29YM0pFem5FRFhrbGpTZWJmNENLQTdYajZrQnBteFp2TkY3alYx?=
 =?utf-8?Q?PqLpC8U5QsM1c4tw=3D?=
X-Exchange-RoutingPolicyChecked:
	T0+aOKk8VRg738aro4WyGoMwdl5bXDmAw7kRpeHjVnNzd3zP2BpnDSRHrgYZl9riMWWwTluiiaOVOUtyACnHGvusxf1DN9437QnP7ngye3rvjxqCnhkIEED3NqRO0kU1eHyJak/Ttgkla0+2/piRxKllDrcUvbCmNpXXJh51QaY9kbuL4CsTF5TL5uvZSU8FSpWSrOEpeFtYPBjuwQI+L+pqETyAWZ/uoLgTD3Ea90FmtYAoGGUd8zo43/C3VnynIIgMCqKXGLBaYVNf9fxQ1zgML2RCj1FqwPYbBpTSOACOnjT76Nk2H1JY8/TgEYp3SqmtzbeFtpDM5bF2m5cVMA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FLSx0i1S8+EleLSEjUtwzyUMILQwynt2uBUhGVydY0jae9R6FPCLfEvvOl9MDWolj81urS4pCAa9eIt/Ky942nzYg4pdH0RLuM7S6l/eOWdyOWZLrFWHdia+2gEIIfplxR+nYSv8ivIp1o6qfLrkzBfx8t7oj0yFnsXmp5jPQWUXicZ9hs3bftBgtmIIuidBBC35YcS45yqWJNIxU5e/VjVUAv6R35qzxINUCi0ElZGJg4FNS9tGVP3KV78z4otBBtsJl3fxs7tt1zUaEstEKLGfY9d+TDiMLMbG1fnBXQjFNrRUYuQXfiSmCXa27TffrfZzMz3rWe7dZlpBqgp/Iq9r7IZ7qqofxMJ1wopmhiNxNjeqDruWRrdCJEHM62X2OEjcW0rz9GJz9qCM341fCZKbpZoYYtmh3jGelk3ZqnCSKjS3+/ng1eEZmhyu5HlyxHoPp7EX6yydUWFF7+0c7Ms3gW08vK/iaa0/3Upjd+sfEcjqh93ostXLrvY6LRjzcxGNIJwkSi5Vc8tY8GqVGsrSLBO/AjGcfSOrtvwzJBxbl2UbmkMIK+kZN5WhPAUcq4PHZc5WVp/NKPAhQbMy3pVCqEVzzvC9yhBHswz6o1uVQUrXUCIh6akIJ4NoZx2+
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e51265f6-5a79-42ea-ee78-08df0cef540a
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 14:50:15.8736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uBFp36tYF+pe7n7JY6ioknkemhuOoYCWIdJ+8ZfG51c5bSfaJsGHV88hHaMNwb0UoJEHQAj9ofQqPJlvSmmba0Bu1jKih0joECItj8Mwyr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7076

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


