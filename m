Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793712756;
	b=Lu9csZ2mAZt4E3Dbfd0zVy6vkjNmCHGDg/PWk9c4BzXd9XSP9sx1d+DgvUaikCPRRQkr
	 DHwXoveVsO51xR6qyWQ+VMGQBkiip7uGqAC99Bvw2eRNOsQO5765OyAT8jzsoaJ3b/H1/
	 lCn6a+a2nbLWZO5xUNr82vXDyQrv86g2eIdxiShxoLvU8pj99fN6KhZHnnsh0gYKQecwn
	 aAxOn293Q0As6d8J53yVo2/VJI7zB+j/ijA0usWNB0Ktu4iK2sqR0eiVhFc+ULJvUwjL2
	 dERAAV/HwsxCucgedbQLyiBKa5PpW0CRpw/PAIIW9Mm4rNnfV5+EdTSkoOnc2hUJ6DA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712756;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:Content-Type:Content-Transfer-Encoding:
	 X-ClientProxiedBy:MIME-Version:
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
	bh=BeNIu+dQw6wZEe/BPdckR7WwYyVjgmo93plXrSSsf8E=;
	b=CiNoMqgqm69WQjwzGLM6yJp9mKTU2SBYzV0ITnx13AmUeAFJVZbKwWaOSek400I0pRQR
	 vdcZtSaV+YHMTjvjA5Ea1HawoG4MIlk9b5Vf6SUq+K3majRL//tPbc9AGTADQLWkEl06e
	 AL6PMhtKP5fL6aQEL1M3HKDqQOtchyX/ySd5toTXAjXjh8DdYiNcNKaKzp3668ScMhBcC
	 PAFOEiAEJcfcPdqhwICmssxiG6fvgWrAtm/byuw4rIh3eZb2Y7ZvsBFZtODj9075ioVBJ
	 wOzvQ7ZNrxJPIePi3bbUCCl1ebZODQjoWAvawiefLI6v631SyaA6QOAJMiWA4HQZTLw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.nxp.com;
	spf=pass smtp.mailfrom=oss.nxp.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=W3zbya3O;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.30
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011030.outbound.protection.outlook.com [40.107.130.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D49D606A32D;
	Tue,  3 Nov 2026 13:32:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D49D606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-NXP1-onmicrosoft-com header.b=W3zbya3O
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z8+GF+zyP3geoC3gVx0A5dLvFEZ3nhtaJ5l/DZHtpcfiLo2YAo9cl21XOo1wWBgeYD5AqJkQemaJtN5dukKgu5GRfY4GTWRMV9JEdLg/WG6VCG/7OHk2eH/Tr6450w62NNMGOhZm7PA0UGV6c5PFE+f1cLOf3bVCuktSSS6yIFFkW5MNQnOfNti/m84k0gsixnHBUreI4ROcfQ9avHSSb+QROsqWgLdiODxb8gPXHWdwMt3e1GNKFyhOCTGuvJn5xeVvnzIm3N+fm2qqyWnNKjbHTDmKZHrc5g7FdJojX8r3ZQeeid7u5wOVu6oCGAEQ+W7r8TiCm/exMVqVU+5fQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BeNIu+dQw6wZEe/BPdckR7WwYyVjgmo93plXrSSsf8E=;
 b=OiWuTkFZ11RWRGK/EHBYGA5/mip5dsDDUXPO+yvRHLand1MQTaNsCeeICO1DQt9/8XH1fR0qvZ46Mkm9kF0G2VDk3KI7AA4Jt6v3nURtDAcQraFFfniOsXp4754DHf4PwnDp8BfoSxsMks5RxRcI++JBqrcO92MNv0umMSbHadQbI2hiB0ozFsY31WDATar79eA115ZSY/Mpu6G0+a2oDCpGUupG8JQYonSAY94pL1R7FrpYqSkg3/ogPajizKTNBENdlzGQz2XZE2ZR5/uzROsFGkhSw6yliNtRIlWmt5SynHfTrO/O8C4uCHZRGZEOXrt4C53lOXfjXLnQwAgIlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BeNIu+dQw6wZEe/BPdckR7WwYyVjgmo93plXrSSsf8E=;
 b=W3zbya3O7zgjHCNKgxYBMMLJkDQJd9nhGz74hlTnoDJo4ibeDjKUsse4jbySqRTcgPL0TUqMZnNoxsCYUAlgHgCz7r3hsgTNi3rGWT3oCERINCHQmhY2WuE2XEAA737MQGDZfd0CmaB2Wca6ObH3hn7lRs/W4P4vZKrPAHXWP4FJ+7rUCt1tA42Yw/MbRmBEv1ViyijfSvO46REG5m9GgI4j454hF6o6QJ6z2LdHS8QwiUqNLus72d9kdPPmprqP8AOlQYi7DEQmcUn2W37DuDHqn5bNrzRYz+L9JC269o2AFWsuIGJSGp33pWvq68LfXH1g6v4f1Kvkl6C0YmqKUQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 (2603:10a6:150:368::10) by AM9PR04MB7634.eurprd04.prod.outlook.com
 (2603:10a6:20b:2d5::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 13:32:30 +0000
Received: from GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49]) by GV2PR04MB12558.eurprd04.prod.outlook.com
 ([fe80::cd9f:102:ea58:4c49%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 13:32:30 +0000
From: Larisa Grigore <larisa.grigore@oss.nxp.com>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
	NXP S32 Linux Team <s32@nxp.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ajay Neeli <ajay.neeli@amd.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Pedro Sousa <pedrom.sousa@synopsys.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Can Guo <quic_cang@quicinc.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>
Cc: imx@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	clizzi@redhat.com,
	aruizrui@redhat.com,
	eballetb@redhat.com,
	echanude@redhat.com
Subject: [PATCH v10 00/11] Add S32N79RDB UFS support
Date: Tue,  3 Nov 2026 14:32:04 +0100
Message-ID: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P192CA0001.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::15) To GV2PR04MB12558.eurprd04.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: GV2PR04MB12558:EE_|AM9PR04MB7634:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ee39d48-4efb-4bdf-89d5-08df39aee89e
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|7416014|19092799006|921020|261102123227099003|261021121427099003|261102130727099003|11063799006|261021123027099003|56012099006|261009223027099003|261028144727099003|261026121527099003|261022075727099003|261026140227099003|261022105027099003|10067099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
 +NutuXwDk2G+eBRI5isaAz1xCArW8fhKoh0/O0zg74Fjh1/mLdWCMVDCAFMljKBFOf55KtgRVcMx41aEdvr8FO9/k3UJx0A+AAmoXLRIVX6iIzGIFtGC4k3peOTQFk941fOQ+hXoseLD9zChOJb0bAoeuiNam5NmRVPcErZVKgjDDeInC8sEAoBR+xFFdhSlM5DrtYfqVmqvbjhCeiIfd1iIuvxbTAaAq76MkNH5EDFLY0Yw9VjWlabUk25ACH6mqMnAnRdt6mQeY3NdZ3B/BJhEYh4MSAcEcQOr4IF78DigGfUf1uJpqK7W35isdIiHJbd5p5YgiPbteBFXthUDD7BxAOMwTMsCmRBrKQUrLI/uApcQYB5JGSdcuf/hqj7xW3kenhZD70Kv5LWIOHmzTSagnus6XOExTA7ZBPtEWv7Gwa8cpIhSQ4mE3kSXyMEOjET4h9Js4XSm6lRBKYDkPGX/9/hleiLlaUZi68QZiEIm+MsKVO0N/pqwFfmWICAzZ/tex0lV8MQqGkcY0Ha6IgGu/lrdTBrA1/3rUIzx7YsJKrt+GwYSdjvDXb8/zUDapth1j1m/53lmJ/oT3gngOOB2KEolqDrYa93a6eeOSPFGwZjhY0GoRYk/ZqVHnyHkaLcRpaXwGpwmt3eWaynyYqvcnlI4Q9L2XgeHl9GvlXd5FwRA4ohGm3zCA6d2iBXS8u9LAfwkRwpDZSvlQZgdWQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB12558.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(7416014)(19092799006)(921020)(261102123227099003)(261021121427099003)(261102130727099003)(11063799006)(261021123027099003)(56012099006)(261009223027099003)(261028144727099003)(261026121527099003)(261022075727099003)(261026140227099003)(261022105027099003)(10067099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?SGpLcXNBbFozWkZEVUVCNit5SksvZVZQcldMN25IYXk1RmUrQWxUSHpJaUpx?=
 =?utf-8?B?K2IwQ2MrM0o1ZmxCcGpIR1gzUS96Yi9PbVBCaWxUaXlYMGRROHBzYnpsNWha?=
 =?utf-8?B?TlltZmU3VEErOFdmaCs3dDl6K29ZaGVsa1BJQ0JMaXhiUjR4b3BiQXJsd2Vz?=
 =?utf-8?B?TkdhSy9MNFdXajlsVVBoUDRUdWtmazVCMlFWSlhqNXNpcjNIL3MxUWwwcG9i?=
 =?utf-8?B?RW1MQ2ZxQitaNnE4NWJQMW5KT2Zld0srZHA4Sm9vTCtITUNHS0lZN1VVUFVu?=
 =?utf-8?B?V0J5QjIySU90QUdKd2pzNmZma2l6S0R0Rno4aXFMcTVDTGZWcHNzbHJUU0hP?=
 =?utf-8?B?WnN3OWZpWUdCSmc4MHoyL0R4dytQdjVYbGQ2S0ZBNGlLcUwwNk5xU0lBbWE4?=
 =?utf-8?B?SzB5UThNK3A5bGd1YnloRk56WVowUnFRMTd4K3FRY0E4Ly8wRmoveSswVEFL?=
 =?utf-8?B?VDZSc2NDbk5FQ0FTUFEvaWtXam9NVVhSMmxhblpkaEhlWEpiWEJNeHVQYUdT?=
 =?utf-8?B?Z0RGMTluMXNZR1c0aFdVYngxVi9vckQ4KzY3TlFGREMxMkJlTWgrdHp2cm9a?=
 =?utf-8?B?QVg3aWJsRHAxTExCeVUrSFFzcktlaHdOMFR3YWd1UjlUMERCcEpvbm4vNklx?=
 =?utf-8?B?VWwwS0RvRUtFUk13KzRMbUdhYVdSNEhBNFJUeDVORnRrd3BQQlZFUk9keFZz?=
 =?utf-8?B?ZUZ1VU9rTGNjUFdGVTRnQUc3NHlXM1dvUVYvdnY0cVAzWmdYdGtGTGdXc1JE?=
 =?utf-8?B?T1E5TGg1WWVTUCtiZ2kvcTlCVHBjeDA1YzV6YUVSUEV2MWdLcWtIUk9BdnIr?=
 =?utf-8?B?Zi9wa09mRjhORDkyOVc4WWNCdFNOTFZ4Q05HSnFMV3hka2tUQVVFaXJET3BG?=
 =?utf-8?B?VWUxRzZsMUlnVEY3VGxjUVFFdDRpYXZNSVpzekdGRWlXS3FSZFhadERCS0NQ?=
 =?utf-8?B?ZTlFN2t2eEljVkNIYlZBZ0dGL3BodnQ4UkR5TUw1Z0FBWFNsQkhhaDNNUkQ2?=
 =?utf-8?B?QThJKzBDODBGY2txbzJLTWJkMTZGdWdHNEhxa3BYZDlza3UycUs5d2FtSUZk?=
 =?utf-8?B?Nlh2b1hqYVVwRkxMcS9RZWpLdkp1VGkvZGt0T0dQQWNVRFhkUllZRVQvZ3Bq?=
 =?utf-8?B?K3F2SUVpRWk1WXRNd3hNL2t0ZEQ0M0ptQng2YXVTWWlqei9lSGlQZmFSbCtP?=
 =?utf-8?B?Q0dLMStUTkh3Vm1jdE53VDVnRUk0L1FIV3hES25OdUpTZG10aVdVak9pZDkw?=
 =?utf-8?B?U3lnOWp5b0ZOb0VOYktwc3N3WWlZTWc5RkdnUG45ZlNLQkM2TGZtZFk4TjhC?=
 =?utf-8?B?RVF5RGR5SWlMN0pzY0kxRW53elRlZ1d3YzBhVWZQWDBKQzlkNzlqMFpNTUdq?=
 =?utf-8?B?UHg3OTlTdTd0RWp2TUhvT2JPc1VCaXgvb05Zcmh4SWRsbTNQd2FJbm41aGNx?=
 =?utf-8?B?ZGdBRWlhNFJMT3dleDNrT1Z6SGVDTFMyOFBBWWV0RHdmVnZ6UmJQRmpKcnhr?=
 =?utf-8?B?RU1SV2g3VTY5L2lyTkhBeU91WU1BaDQ3QnJnVVNEeWxSN0xpRXJNWU1jVU1y?=
 =?utf-8?B?RTRGcUtTZHBiVjBxNDd3cHZ1MEdDbW55WGhrRWdmS0JyQ2YrN1VWdHlqMWJT?=
 =?utf-8?B?SXhtWTRWaFFnT3BWR1lzVmd2VDFHMGQveTZyMEhjQWE0MnFPY0hPK2ozeXlw?=
 =?utf-8?B?S1ZHbDBNOWJ4cys4K0ovVG9zMlMxSUFtZldHT1VzdXZ6aEVlbjVHdUZYdzlD?=
 =?utf-8?B?STJXVmxxb3dtdlZsMUFtQTBadkx4S3RkUWF3SnZ3c0JTcU5uTis3dDZXazNT?=
 =?utf-8?B?eWJGWEtUeFhjRnVITDZ4SG5XSWkwZ2pPMFdRR3Rnd3U1dlJvWjkrcnhyMjRn?=
 =?utf-8?B?Y0NIVUt5ZWxqUkltUWlXUWxwUGtXdlh1OWRYU001V2ZvVzA1SlRVMmlCNVNY?=
 =?utf-8?B?M0YwYkY1SG9mcGhlSy9mdkViRFFjN2NHbXExOFFUMGpYcThBMnA5N1JmRnIr?=
 =?utf-8?B?OTZJaGJCRVNoNWMycnpGbmpBWU51QXhSa2NBQzZKVHR3ZmprWll0ZkFYRTlB?=
 =?utf-8?B?aUc1Yk9Nb1NmbzBnb0FLbGg1cXdWb2lBRUZoY2llRlNCRmZiSk5Oc2sxdVJK?=
 =?utf-8?B?NXJhZ2xHVitlYWJoUHp0S1FWaTFpeGFWd1FYckwzSEdMNFVEYUJBSFQvL2ZV?=
 =?utf-8?B?bXdyMGlJY0wyaGRSazJaeHBXM0RobzRpa2w2SXBvbkxlNmxMdXkyY1hPOGFN?=
 =?utf-8?B?WERHWTRyK0hxempBaTNTMzB4a3N6TUw0ZVp3dHB0Rm9DaXdCWFl1TDBRano5?=
 =?utf-8?B?NUlQZDE3dm5UMUF3Z1A1QlZmeGp4bk9QbUk1ZG1yZHo1UUQzUnJPUT09?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee39d48-4efb-4bdf-89d5-08df39aee89e
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB12558.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 13:32:30.0868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ozzm/S6/ZicY4rQv9W03TaDmy4ilXoGyRAPo9h+cdXhZ9PiTNW43HRNCzlKzC4v+0LiJuP24LopZFNxfb8U6UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7634

This series adds support for the UFS host controller found on the NXP S32N79
platform. The controller is based on the Synopsys DesignWare (DWC) UFS host
architecture and requires S32N79-specific M-PHY initialization/calibration
sequence. It is compliant with JESD-223D "Universal Flash Storage Host
Controller Interface" v3.0, and supports up to HS-Gear 4 speed grade. It is
compatible with UFS 2.1, 3.0 and 3.1 devices. The MIPI UniPro is compliant with
"MIPI Alliance Specification for Unified Protocol", v1.8. The MIPI M-PHY is
compliant to version 4.1.

In order to keep the S32N79 platform driver small and avoid duplicating common
DWC code across platform glue drivers, the series also refactors and exports a
few reusable DWC helpers. In particular, M-PHY CREG (CBCREG*) register access
helpers are moved from the existing AMD Versal2 glue driver into the common
ufshcd-dwc layer, and are then used by the platform drivers. The series also
introduces a generic Hibern8 TX-FSM polling helper so that multiple platforms
can reuse the same pre-link checks.

Device tree binding documentation for the S32N79 UFS controller is included.
The SoC and board DTS updates that instantiate and enable the controller are
no longer part of this series and will be posted separately.

Changes in v10:

All patches:
- Dropped the "scsi:" subject prefix.

ufs: core: Return a negative errno from WLUN suspend/resume:
- New patch. __ufshcd_wl_suspend() and __ufshcd_wl_resume() may return a
  positive result code, e.g. from ufshcd_link_startup(). The runtime PM core
  treats it as a failure, but rpm_get_suppliers() only checks for a negative
  value, so the LUs consuming the WLUN are reported as resumed while the host
  is in the error state. Convert positive values to -EIO at the WLUN PM
  callback boundary, as ufshcd_init() already does. This replaces the
  Fixes: rationale previously carried by the dwc link_is_up() patch and
  covers every source of positive values, not only the DWC glue.

ufs: dwc: Return a negative error if the link is down:
- Dropped the Fixes: tag. The PM-boundary issue is now fixed in the core;
  this patch is a cleanup so the helper returns an errno before it is
  exported.

ufs: unipro: Add TX/RX FSM state attributes:
- Fixed the commit message: AMD Versal2 has no header with these
  definitions, only users in the .c file.

ufs: core: Add common Hibern8 TX FSM polling helper:
- Changed the subject prefix from "ufs: host:" to "ufs: core:".
- Fixed the helper name in the commit message.
- Renamed the internal per-lane poller from ufshcd_poll_tx_hibern8_lanes()
  to ufshcd_tx_lanes_in_hibern8().
- Log the TX_FSM_STATE of each lane that did not reach Hibern8 on timeout.
- Moved the prototype to the non-extern declarations and dropped "extern".
- Report a positive UIC result from DME_GET as -EIO, so the helper really
  returns a negative errno as documented.
- Fixed checkpatch --strict alignment checks.
- Dropped the Reviewed-by tags of Frank Li and Stanley Jhu, as the patch
  changed significantly.

ufs: dwc: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc:
- Reworded the commit message and explained the static array race.
- Use the "name() - description" kernel-doc style like the rest of the
  file.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Restricted lanes-per-direction to 2, matching the driver.
- Explained in the commit message why clock-names and the single 0 Hz
  operating-points-v2 entry are required.

ufs: s32n7: Add NXP S32N79 UFS host controller driver:
- Changed the subject prefix to "ufs: s32n7:".
- Added <linux/bitfield.h> and <linux/bits.h>.
- Reject lanes-per-direction other than 2.
- Dropped redundant error messages and the remove() wrapper.
- Used u32 for the ufshcd_dme_get() result, aligned register offset style,
  clarified the SCM_STATUS comments.
- Documented the PERFORM_LINK_STARTUP_ONCE quirk and spm_lvl in the commit
  message, and updated the HS rate-select bullet.
- Documented in the commit message that the DWC BUSTHRTL power gating is
  disabled because it is not supported on this platform.

Changes in v9:

ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h:
- Prefixed the RX_STATE_* and TX_STATE_* enum constants with UFS_ to avoid
  polluting the global namespace, and updated the existing users
  (AMD Versal2, HiSilicon, Qualcomm).

ufs: host: Add common Hibern8 TX FSM polling helper:
- Use the renamed UFS_TX_STATE_HIBERN8 constant.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Added Reviewed-by: Frank Li.

MAINTAINERS: Add NXP S32N7 UFS host controller entry:
- Added the imx@lists.linux.dev mailing list.

arm64: dts: freescale: s32n79: Add UFS host controller:
arm64: dts: freescale: s32n79-rdb: Enable UFS:
- Dropped from this series, as requested; they will be sent separately.

Changes in v8:

ufs: host: Add common Hibern8 TX FSM polling helper:
- Added Reviewed-by: Stanley Jhu.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Let the UFS core manage the core reference clock: declare it in DT via
  clock-names/operating-points-v2 so the core adds it to hba->clk_list_head
  and gates it across system suspend and runtime idle. Dropped the manual
  devm_clk_get_enabled() and the struct s32n7_ufs core_clk member, and now
  read the clock rate from the core clock list.
- Dropped the ufs_s32n7_calculate_us_tick() wrapper and inlined the division.
- Dropped the unused struct s32n7_ufs hba member.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Added the required clock-names and operating-points-v2 properties.
- Dropped the Reviewed-by and Acked-by tags.

arm64: dts: freescale: s32n79: Add UFS host controller:
- Added clock-names = "core" and an operating-points-v2 table with
  opp-hz = <0> (fixed-rate clock) so the UFS core manages (and gates) the
  core reference clock.

Changes in v7:

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Wrapped .prepare/.complete in pm_sleep_ptr() instead of pm_ptr().
- Fixed code alignment issues.

Changes in v6:

scsi: ufs: dwc: Return a negative error if the link is down:
- Translate a positive UIC command result from ufshcd_dme_get() into -EIO.
- Declare dme_result as u32 to match the ufshcd_dme_get() parameter type.

scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset:
- Added Reviewed-by: Frank Li.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Added Reviewed-by: Frank Li.

Changes in v5:

scsi: ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset:
- New patch. Split the macro reorder into its own cleanup.

ufs: host: Add common Hibern8 TX FSM polling helper:
- Return the real poller error on timeout, not a forced -ETIMEDOUT.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Dropped the jedec,ufs-2.0 fallback.
- Removed the select: block and the clocks description.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Documented the timeout values as driver-defined bounds.
- Wrapped .prepare/.complete in pm_ptr().

arm64: dts: freescale: s32n79: Add UFS host controller:
- Dropped the jedec,ufs-2.0 fallback.

Changes in v4:

scsi: ufs: dwc: Return a negative error if the link is down:
- New patch. ufshcd_dwc_link_is_up() now returns a negative errno on failure
  instead of a positive value.

ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
- Added Reviewed-by: Frank Li.

ufs: host: Add common Hibern8 TX FSM polling helper:
- Refactored ufshcd_dme_check_tx_hibern8() to use read_poll_timeout().

scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc:
- Added Reviewed-by: Frank Li.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Added Reviewed-by: Frank Li.

Changes in v3:

ufs: host: Add common Hibern8 TX FSM polling helper:
- Use -EAGAIN while polling and only normalize to -ETIMEDOUT on timeout, so
  real attribute-read errors are returned instead of masked.
- Drop the stray delay.h include in ufshcd-pltfrm.c; the helper lives in
  ufshcd.c.
- Drop the now-redundant dev_err() after the check in the HiSilicon driver.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Use devm_clk_get_enabled() to enable the core reference clock.
- Rename the family-level identifiers from the s32n_ prefix to s32n7_
  (structs and functions), keeping the s32n79_ prefix only for the
  chip-specific data.

Changes in v2:

ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h:
- Improved the enum comments. They now cite the MIPI M-PHY v6.0 tables.

ufs: unipro: Add TX/RX FSM state attributes:
- Added Reviewed-by: Frank Li.

ufs: host: Add common Hibern8 TX FSM polling helper:
- Moved the helper into the UFS core (ufshcd.c).
- Split out an inner per-lane poller, ufshcd_poll_tx_hibern8_lanes().
- Expanded the commit message to document the -ETIMEDOUT normalization done
  when converting the qcom/hisi checks to the helper. No code behaviour change.

scsi: ufs: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc:
- Made the DME attribute arrays const. They are now initialized inline instead
  of by later field assignments.

scsi: ufs: dwc: Export common clock divider and link status helpers:
- Added Reviewed-by: Frank Li.

dt-bindings: ufs: Add NXP S32N79 UFS host controller:
- Renamed the patch subject and simplified the commit message.
- Renamed the binding file to nxp,s32n79-ufshc.yaml so it matches the
  nxp,s32n79-ufshc compatible string.
- Removed the nxp,mphy-boot-mode property.
- Made reg-names and clocks required.
- Removed the conditional if/then/else schema.
- Removed clock-names.
- Changed the compatible from jedec,ufs-3.0 to jedec,ufs-2.0.
- Updated the example clocks to <&clks 0x92>.

scsi: ufs: Add NXP S32N79 UFS host controller driver:
- Removed the nxp,mphy-boot-mode handling and the mphy_boot_mode enum. The
  M-PHY firmware always runs from ROM now.
- Added a struct s32n_soc_data for SoC match data.
- Moved the calibration writes out to static const tables.
- Renamed struct phy_reg_cfg to s32n_phy_reg.
- Moved the rate-select sequence out of link_startup_post_change() into a new
  pwr_change_notify() pre-change path.
- Used devm_clk_get(dev, NULL) and dropped the redundant core_clk NULL check.
- Switched to *_PM_OPS() macros and pm_ptr() for the PM ops.
- Clarified the Hibern8 poll timeout comment.
- Enabled Auto-Hibern8 instead of setting UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8.
- Reworked and improved the M-PHY initialization sequence.

arm64: dts: freescale: s32n79: Add UFS host controller:
- Changed the compatible from jedec,ufs-3.0 to jedec,ufs-2.0.
- Removed clock-names.

arm64: dts: freescale: s32n79-rdb: Enable UFS:
- Removed the nxp,mphy-boot-mode property.

Larisa Grigore (11):
  ufs: core: Return a negative errno from WLUN suspend/resume
  ufs: dwc: Return a negative error if the link is down
  ufs: unipro: Move Tx/Rx FSM state definitions to unipro.h
  ufs: unipro: Add TX/RX FSM state attributes
  ufs: core: Add common Hibern8 TX FSM polling helper
  ufs: dwc: Move Versal2 M-PHY CREG access helpers into ufshcd-dwc
  ufs: dwc: Export common clock divider and link status helpers
  dt-bindings: ufs: Add NXP S32N79 UFS host controller
  ufs: dwc: Sort CBCRCTRL and CBREFCLKCTRL2 by offset
  ufs: s32n7: Add NXP S32N79 UFS host controller driver
  MAINTAINERS: Add NXP S32N7 UFS host controller entry

 .../bindings/ufs/nxp,s32n79-ufshc.yaml        |  68 +++
 MAINTAINERS                                   |   9 +
 drivers/ufs/core/ufshcd.c                     | 101 +++-
 drivers/ufs/host/Kconfig                      |  12 +
 drivers/ufs/host/Makefile                     |   1 +
 drivers/ufs/host/ufs-amd-versal2.c            |  97 +---
 drivers/ufs/host/ufs-hisi.c                   |  48 +-
 drivers/ufs/host/ufs-hisi.h                   |   6 -
 drivers/ufs/host/ufs-nxp-s32n7.c              | 537 ++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c                   |  42 +-
 drivers/ufs/host/ufs-qcom.h                   |   2 -
 drivers/ufs/host/ufshcd-dwc.c                 |  86 ++-
 drivers/ufs/host/ufshcd-dwc.h                 |  39 +-
 drivers/ufs/host/ufshci-dwc.h                 |   6 +
 include/ufs/ufshcd.h                          |   2 +
 include/ufs/unipro.h                          |  22 +
 16 files changed, 876 insertions(+), 202 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/nxp,s32n79-ufshc.yaml
 create mode 100644 drivers/ufs/host/ufs-nxp-s32n7.c

-- 
2.43.0

