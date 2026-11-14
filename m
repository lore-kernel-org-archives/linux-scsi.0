Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794652208;
	b=O9F0g3+X2aHwBiMO8BkOU8TaP1KRma/RmWQxA7maKuLVXo0JgS+XvDfW724o/54z60Y+
	 Jr9yWHrJZpbnTcyY5uCOjsTJX7QoebIvGvKjnor/UeYaE9Zs6pk1hlRdr8Pqh5GHaGHka
	 erQ8UcMj7FJ4nGGiW9yoXeJed++QlO+uW2Q1X/AW1WIy4h7TyfoNTV9l1UUZlNJen+/ls
	 M29qKvRjYIH7uIVYSHAsBTyDhkbhGiZf/VTFiqOluu3BVJnMphsdUXlQuFpQn4DIQgvbq
	 VWC2V5+L/DzfBSPX8c/2JLcc7eMx71rL6FM8Hze+t49n2n7LgNgZaFJ89wvUtJIdvPA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794652208;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SharedMailbox-RoutingAgent-Processed:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ni5wUL/ouLvju/iZw2Qmz76p9RjiGbOTG6bIq6TmJNc=;
	b=F9vo921sOTgrHCSJRPMLRhFPaXsULyGpwcvjuDWaVdE5Fvs+gcBLef3LuXIjLA8btnOm
	 JD/H1iZb0vDAhfXySMvPmWO7mzq4puoahp/7fHKA3+MJDO8W1fl9U+9ICSPSYNv15Kk26
	 ZfCneljs2XR1yoidEDfQ0pC5nbU/brmSaM0H09oic4Gywj1uAw8pj7opJSSKcVIDxbwBn
	 QPBrD6UIA6sr95k2e7tiemPN2rtq2XViGnY4maCNRON2E2/Hx/5W1/XBZpqKUFE+HIoP+
	 uQmF4OrDM69QFLSPAXRuxsyHGDBAT+WFl73qlk+8AByW7h5UfdmC4Eg/fBNH8FntIIQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=LFIQCLGZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.70.65
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011065.outbound.protection.outlook.com [52.101.70.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0C9606A338;
	Sat, 14 Nov 2026 10:30:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F0C9606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=LFIQCLGZ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E13eQLZVLFDOCidKQL1xk8pmslx9pT09cjkYVXWsX9cf21UdUv6E/2UBUdWA8TFVAhBz9KGYepWbPE792LRId1o1WEQScDHoYQpWnx1aejbjTBXDblhImCPec2ZnxCIUNVK0Z2HOwGSN/6OBPdbpeB4jEBvAE59tU7wORsmeSsa0nVYw7bIpRUQytPDoKFYDFJA8kI8e2nJxF1CnEgu5LK4feQZrHtuvohyTwSM9aFz2UPPJWmpqi3cDj9WLgv4fD+O9x16ibU5KU50DxYwxeqQ51GjPqcpySSWpIGFeB3Kj3a/7twn8fLcz741oDBz26MylC2ofGsKEPAFG8faTCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ni5wUL/ouLvju/iZw2Qmz76p9RjiGbOTG6bIq6TmJNc=;
 b=lLumWkkxaGDLsFVQBYUmfxzW/1iLe8AlhtKW3AFD30ckhltR+IylKGwEcvVwHclCNCVpyj/f9QYCkVQkF/urkXfa7WhqGB8Q+IA4F9DQ26NpeCnoRCiSA5w2SRbIOvb6YttBOn+Wk6/2QdXzA0vk39MEo3WkLnGQsky0lZKzJUciWnI/RdtIADVK/XrhcE4lb3olUY5QiaqzdKJQA6qX4aEMBb+nnwH/eoFcd9cByok9o4cc0MmSk6C6/ip2ClPm+mSysH437NYxpfZLvOwelM1enZeQ5PlXVGTMd04cic6ErmfVMCOSnsyjDMe+xhKFYX4FwcKYZLie/fyaoc/ZXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ni5wUL/ouLvju/iZw2Qmz76p9RjiGbOTG6bIq6TmJNc=;
 b=LFIQCLGZZJeMC9AHS2Ok3evfzL3qqdxD3R92lt5hYWslZY6yfwvC6/d5EridkQsWN+3NbtejmOA3QU2MdznToi4rcHJjzRHH6DmQWjoSmO0O5+VNBzJRhcD9k46W3qYbTJA54ct1WwFkU6CFryroy/uUpjR1YXsPGkCnrbdURO4K2IdSdgGXVtqY/bcWqeuj9LdaMwlDDzGEShfI1FiwwXFmj4VbMSKP/84t1HxHoD7zNh0L8+UB9HLcYnR55moSoZfMrplcow5kbzvfwCYsXSekL0J7aGuzxn6dAx2qDWengDPfHpgQJo+zPTt5iIevYT1VWG9k1Ki7Tbmv/GDTkw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AS8PR04MB9206.eurprd04.prod.outlook.com
 (2603:10a6:20b:44d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Sat, 14 Nov
 2026 10:30:01 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%5]) with mapi id 15.21.0615.009; Sat, 14 Nov 2026
 10:30:01 +0000
Message-ID: <141c8478-c927-4bde-beec-9f5f5663bd92@oss.nxp.com>
Date: Sat, 14 Nov 2026 12:29:56 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 10/11] ufs: s32n7: Add NXP S32N79 UFS host controller
 driver
To: Bart Van Assche <bvanassche@acm.org>, NXP S32 Linux Team <s32@nxp.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Stanley Jhu <stanleyjhu@google.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Can Guo <quic_cang@quicinc.com>,
 Asutosh Das <quic_asutoshd@quicinc.com>
Cc: imx@lists.linux.dev, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, clizzi@redhat.com, aruizrui@redhat.com,
 eballetb@redhat.com, echanude@redhat.com, Frank Li <Frank.Li@nxp.com>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
 <20261103133215.1385823-11-larisa.grigore@oss.nxp.com>
 <444b8e4d-948a-48de-b40e-74246b849842@acm.org>
Content-Language: en-US
From: Larisa Ileana Grigore <larisa.grigore@oss.nxp.com>
In-Reply-To: <444b8e4d-948a-48de-b40e-74246b849842@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0012.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::22) To GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AS8PR04MB9206:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d259e9a-e48e-433b-b688-08df423a3d2f
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|19092799006|366016|921020|10067099003|56012099006|4143699003|11063799006|261021123027099003|261026121527099003|261022105027099003|261026140227099003|261022075727099003|261022115727099003|261028144727099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 PHiG168Xqxw1i/XETy7GaTdqzP5GNbwETDe17ktM0O1Sq8qtVznlu/UcunkSigEmHrIjCBoPwq2GzA9zM2aWKTEYc6U7+HS+raBcC/SFc+cZF56a8KLRwZx4AVK8eQWgCTUosngJpxUixaP2hTplJwfXOVvTHsq1+3PxAt5fJTSgCZT420vvTgIBtgqBsCoce/lv66VrbRf81rWBnz0QQWsPkRllbkNPMtU7CByFvhIy25iJ9BRX17eh414G1on+oeoSXY9BiiRPf1+CnEAo+YaLmonqCds3zdBu7/recTgxBF72LmPJTiiuWrMR5LowvDiB+cbtoRzH+UNiGSWFThiOeNvv/FKwF6tDxmcmtRS7lpA58m6Gs+xWOjzXg7rRQIBlvt0/JrMOXsLdTQYynDdIFlF2Msjs3Rc3IqySNGJtw3p+/+GFSI4XQFQCHn7AYtIJob01lxD+mJBq/gyMuKPEqWHpFuiRZByzH2sAYAYlCCAUlgM6zGJuuP6Pqe5eX8iTQANFNdu4wGBC8LS8dhPIXA7JqF1p1WWqsYYmyOhs/8t3PPcbWC+JntfT3ZksbaT+VEaaK+oloQIgQUmHLFub+dVygBvAxF2FAZd6mBk9vH0nO6+aeN8iVaMqTq4lSGQ3qJvaOyaUGFZqR3/i92jqD4p4nXYwEJCabFi9Mp4khquvBMNViAnJFreb9d31DlRn0iuJfwVNj7xlobX6gg==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(19092799006)(366016)(921020)(10067099003)(56012099006)(4143699003)(11063799006)(261021123027099003)(261026121527099003)(261022105027099003)(261026140227099003)(261022075727099003)(261022115727099003)(261028144727099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?YktIUnN3dy8xRFhPclZVYUlBdE9HSkl4TWxPcVpiOEhTZWtTL3NMZVR5MlpR?=
 =?utf-8?B?UFVKeFN4MFVnRFdEU3VWaHNzc1dVQUpWSUVTa0ZhVHFuL3FhYWo5MFhsYXFx?=
 =?utf-8?B?SURvN0IzWUswdDRWUXRuc3NOVHc5aFNPdDFCdUdoRzBUUDJnTDdjNU8zeGRi?=
 =?utf-8?B?U0tsYkJxVVdUMVp6VUdyNTNtMHJUdWdwckhCbkxxR1hESG1HcVNWU01kWGtR?=
 =?utf-8?B?ZlRSc3p2NTk3cVV2OW8vQ05uUllQajBCVm5rRmROQ3hnRmR6L1ZSeXdiWHYr?=
 =?utf-8?B?UzVNY3R2VFN0b1I4WCt4NFNIYTIxQzNCMHF4SVVHT2JaMkZvUjRGZkVtRzJ5?=
 =?utf-8?B?cWlHZDRpM0dISkNsT05pa3pIL3BoQTkvRnJEbmYrYzFQU1Nta3VyRWhXVnI4?=
 =?utf-8?B?cElqODRKWk45YlREZlVsVWtCMlBTaDczSURNWDg1cWtNNXVYeFdIclhaYjdm?=
 =?utf-8?B?SVh0eWExbkpHVGJpOE1yeHVTUm10M2lhVExBSk9SR25wRitlcWV2THpXOTRK?=
 =?utf-8?B?cHNyYVFPbUhyTjVjRHJYT3BNczFYMWg2UFFyNHg3QzhyOEMzclBWT0xLSWp0?=
 =?utf-8?B?eUVTZVBid1lUazRjenZhMnFqZnFmaWpFQ20zQ0hnMWhWSE4rdFpyaGxXNTht?=
 =?utf-8?B?WjFQcW4vVVd6U3JFcTFpRTNzTDQ5UEluR3pPZHdqZUtHTUprUWQwZUFXYnNE?=
 =?utf-8?B?YndQdDJ1QWYvVzM4T00rOENGYUJsaDFpYWV3azNpV3ZqN2F6Ri9GVGZyY01L?=
 =?utf-8?B?cVVSUkE2YUl2MEhIbVpBeUZIaXhwTVVGZmdqc0h3eis3Q3labXYvWWc1WFVu?=
 =?utf-8?B?NVA2MlNSRlVzOVp0V3ZhMGkyd0pIaVh6Wmh6VnJGV3o1NWEwell0ZEdHbElq?=
 =?utf-8?B?K1E2QVRubGJVS283eGxnV1JhOXhCUmtZc2NVeFJ1L3Uxd3FSaHorT2RpMjR4?=
 =?utf-8?B?RTJoZWcrYlIxdmZrMVlhYlFDeDk5QXdNNG41YlFZTXdlN1Uxd1FCWkFTNC82?=
 =?utf-8?B?Rlgrck9jV21IcDU0dlBLVC8xK2loRVZjTG9YNGtpZmxSSFo5OTlNOE5aZ3Y2?=
 =?utf-8?B?NGY4dUZlQkp6ZCtINDAzWVhYYUxCaEQ5MmM0NWVFdW5NVVRIa3NVSW1ZbXlo?=
 =?utf-8?B?WW5FZ1hhZlB5QXlZcVowQUhFTjlMQ005N1pHZU9wTjlPNkZ5OCt0SlViQzhF?=
 =?utf-8?B?OXhtVzV6T1lUNDBydDM0U2F5cjl1MXM5Q1U3WUVTU3c5UDlkT3pqTm5iODkx?=
 =?utf-8?B?aGFadmZSdGEzVlp1V202ZlJTTDhzSlBPSCt6cDlEMmRUZVIxdWRGYXNwVXJw?=
 =?utf-8?B?THZwVVVUUkdBcmRuTUpJZVlTTDZuWk5JbFJDb3ZLZ01qTmcrYjNxNHM4NEdp?=
 =?utf-8?B?cTJnQ2RSYVI5NDRja1MxZEhtMkszbzVlYThJQjI4cjlEQzNSNjh4eThscmhD?=
 =?utf-8?B?L2ZJczZsZGUwMGNETngwWk1NSGtWVWFmVlVmNEtiVEZTQTNNU0VkQWFnUUE0?=
 =?utf-8?B?MGw1Y2g1MmNNdkYxdnlidkQwVlg0OWVzakdsdEpzRm1MTGJQWFo4bDZHVTd3?=
 =?utf-8?B?Nm5lV0dEVWdlSVZkcm80SzlZZ2ZWUCtwT05nQVBuY05MNk5XcFNDZjJFNWh1?=
 =?utf-8?B?T1NCT3kxdlNHSkpVVmF0VU1GaTRQWms1ZWJDeEZxL1FhY2hKT2N6UStEb0R3?=
 =?utf-8?B?ZjB4WGF1K1FOSVpxZkdmSVVDaWFJNTZZZ2lWN2dnVjdpbGRyK1JJMEROc21F?=
 =?utf-8?B?YlUwQmQxdnA1WVRxMkIyYnV2enlqMjRXQUNzQnBPb1JGbzVNdWs5UlpDS3FB?=
 =?utf-8?B?Mk5lbmdPVFNKc3g1eUl4RWpmYThvQnhmN0IrclVKVTZyUG82RkNvSTBpUWph?=
 =?utf-8?B?Kys5TXVwVTE5VFovYm5XOW1Ud2VDZVB1MjFJdTdNVTBTbURtUDI3b3dPUlp0?=
 =?utf-8?B?cG9nVUJwOHJFWjZ0VkxZeFh2R0YrWXZ4RnVBb1dic2ZuL0VkQWxQb0FCdUpC?=
 =?utf-8?B?Ykx0SDF3OVVPbmxYbjIrbWtSVUJGY2UwYUM3YkFqcnBTSGFRaEp2SHlWdGsr?=
 =?utf-8?B?a20yQWhON1JGSGVEMmF4KzRDMkE4OHp2OG00V2xZOVBPMHNQeWFzUmREVnhO?=
 =?utf-8?B?cFR5WEpGTzZWbFBFTGVPaEVPaE5rQUFpemN1cXJCMVlFZWo5N3dGcW5MTTVR?=
 =?utf-8?B?UVlFSldMUUNiajQrYUdMS084TlVDZjBXYTUzcWJLcWlSd0xQSEo2ajRsZWth?=
 =?utf-8?B?dDZWZW5ZWmxKUUM5bHBZdnc5QTltS3VYVG5QY2Jid2QvWUczaUhjcDdsZ0ZB?=
 =?utf-8?B?RUtRKzg5Znl2MlRrb095N1F1eVFRTE5GWERZK1JhQWdwcU9vOE1tb3M3VHFL?=
 =?utf-8?Q?5A44Bkr4YBPXoVeo=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d259e9a-e48e-433b-b688-08df423a3d2f
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2026 10:30:01.4085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: drhXwwrlU8ubWzcZnvlbysnYdXj+vYQDTolBCfXiH/wRb+iWwjiYlH+NmN5qRUc2PlAfvv51EVoJQ9GtCg6DPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9206

On 11/3/2026 7:57 PM, Bart Van Assche wrote:

Hello Bart,

> 
> The following comments posted on v9 have not yet been addressed:
> * device_g
et_match_data() is still called in both ufs_s32n7_probe() and
>    ufs_s32n7_init(). Since all S32N7 variants use the same vops callbacks
>    (or vops can be embedded in struct s32n7_soc_data and recovered via
>    container_of(hba->vops, ...)), one lookup suffices.

Will be fixed in v11.

> * ufs_s32n7_link_startup_post_change() still open-codes a local-only
>    subset of ufshcd_dwc_connection_setup() (setting N_DEVICEID = 0
>    without N_DEVICEID_VALID, and skipping peer attributes). The v10
>    commit message states this "follows the Synopsys recommended
>    sequence", but still does not explain why
>    ufshcd_dwc_connection_setup() (used by ufs-amd-versal2.c) cannot be
>    used on S32N79.
> 
After re-checking the recommended S32N79 sequence, v11 moves the local 
N_DeviceID write back before link startup, as it was in the initial 
version of the driver. After link startup, only the local CPort 0 is 
touched (T_CPortFlags and T_ConnectionState). So the S32N79 sequence is 
not a subset of ufshcd_dwc_connection_setup(): the two sequences program 
different settings. The S32N79 sequence does not write N_DeviceID_valid 
or any peer attribute, so the values brought up by the controller are 
kept (host N_DeviceID_valid = 1, device T_PeerDeviceID = 0). The generic 
helper sets the host N_DeviceID_valid to 0 and the device T_PeerDeviceID 
to 1.

> Other issues:
> * Back-to-back writes to SCM_STATUS: ufs_s32n7_link_startup_pre_change()
> performs two consecutive posted writel() calls to ufs->reg_scm +
> SCM_STATUS (SCM_STATUS_PHY_RESET(1) immediately followed by
> SCM_STATUS_PHY_RESET(1) | SCM_STATUS_SRAM_BYPASS(1)) with no readback or
> delay in between. Either the first write is redundant, or if the
> hardware requires observing SRAM_BYPASS = 0 while PHY_RESET = 1, a
> readback/delay is missing and should be documented.

The first write is not redundant: PRE_CHANGE also runs on host reset and 
error recovery, where the PHY may still be running, so it first puts the 
PHY back into reset; the RM requires no delay or readback between the 
two writes, the comment will be updated.

> * Magic hex constants for shared DWC M-PHY bitfields:
> s32n79_reset_config, s32n79_calib_mphy_disabled,
> s32n79_calib_mphy_enabled, and pwr_change_phy_regs use raw hex values
> (0x8A for CBREFCLKCTRL2 even though ufshcd-dwc.h already defines
> CBREFREFCLK_GATE_OVR_EN, plus 0x4, 0x100, 0xc, 0x8). ufs-amd-versal2.c
> already defines MPHY_FAST_RX_AFE_CAL, MPHY_FW_CALIB_CFG_VAL,
> MPHY_RX_OVRD_EN, and MPHY_RX_OVRD_VAL for these same registers—moving
> those bit macros to ufshcd-dwc.h would avoid magic numbers.

Will be replaced in v11.


Thanks,
Larisa
