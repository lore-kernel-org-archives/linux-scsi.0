Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2084.outbound.protection.outlook.com [40.107.255.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F7A22A7FC;
	Mon,  7 Apr 2025 08:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744016274; cv=fail; b=fkAiqwbW7/xdCwiHAs3HqPOcA7WMXK+z/CDZY6jxYNqnFG5THBqb7rzqCRy8rkdjzAXt/05MX2VUuM4Q/sdTXdNfzoCrNUPeXZl02Z09jp81W624kk0WirUNtUIje0rAVuzKFZTGzZnzxX4pwazm9ygxTTzJwkg1RCOgLop1DE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744016274; c=relaxed/simple;
	bh=brhqBFg9ILkxApeMtdBMA1/3V6ZoAemo7co4pg0EMf4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t+7upA2QWCdtlsFfxHHNF97VLUuGMh9PiECIBeahWx2FcAwrNVJ9FDzyC+qlfcxN5ZFIrCb2mjqMMaoKcxZrz75KVpCcmVTVTGGFFHshM+zmLjrJGaj+aOy6vVMj1ln2SGWr49VA3xH/LPrW6Ybj9GwgaWbIuM7R8l4zSewkuNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=G4NNZICY; arc=fail smtp.client-ip=40.107.255.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="G4NNZICY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RPt4Liqy2Bs1jNIy6GnL7vWcnd0NrVznifl+k0kSI/aZXI56hkzoxZumIkCpNrWi5mOGXRvMKoReSZXy+Mi1F6VAB8hZaqwv+gcQO/c6qTcJlzuZTa9mbMZbGunFAJsaBLOZk2SfGoqL6VP7++EmSWhlZQX6nxjA/1Zecosy71f/ii+Yy+nDyyE+f0fEMSMmCPsCMbJi9AfB+W0ez7d/UnArx1aftNX4oNmbcU2FyudhCTueuJpEHQXv0MYdnoN5dJRRW5HreHshc5QEN5SHpc/DSlu6/8eVIWT5VjYYJw4PzgHd/hI2p77sTF+uGfsZlAzkBVHfMDYG3AXKTX2NEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Rowf3RBe83LRgcGoiCo/tJsA81+/dDOBLLPLNrtou0=;
 b=omLjNyFArhWJVU4Fro8av8kI/xd+oIDmwJs71lc7tf/6O96yNV8QPnqkAZp8nlBS200M5lKeM/oec3rR2k7shnb5GgbUaJ3le/lx9PcaZt1w1g95UfO0Rue1CM4KkhjR7pnhKrkapNKms3wmhtHLHMRReOTWeMRE//ZOhRVrFzH9S3vV24Wds1M8UXsNidgci8qtcZm1sSDKdozkCK9XrvRqxUToPKdEHgsheDp62MaV/yPdzhc1wnHn5H+oI897rg5vTIVQpEsWQa8MJPlKvTeuRZLFdcRCv8x4VxL3CnZp9XqN4tf+2XZaqrTpHdk1IV6qUssgemylF9yeKR+CAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Rowf3RBe83LRgcGoiCo/tJsA81+/dDOBLLPLNrtou0=;
 b=G4NNZICY6ZEk6eI+i7680xpc7D+71w3zQCgkYhYyK39nWLjy2aFUQ3x0kzQRixPJf9H7CVv7OwAT1UflaLz797KKitegKXWLt6x6uHw+YRTYtbegHhJzjRVHpKyTFKOeUXtIHG0GJ6Ugsm4U0p8rWNd5XiKGooA0DXCBqXc200Xy4OuSXT+6myRPDQp5yjbnqGzyJ62rVsVLmGWEjAHdM30vTNbI1bg7kFuNtqbaigWqIzijn7Y1l0vWulYVOh2PUv+eW6jEeGqSr6aZbg3R2N66sQelLRDI5ZDFJMsE97LUACc9LiM1S8SW/QUsaEGEnu6iDGyjK+7BgYMVjdNPgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SEZPR06MB7002.apcprd06.prod.outlook.com (2603:1096:101:1f4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Mon, 7 Apr
 2025 08:57:45 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%3]) with mapi id 15.20.8583.047; Mon, 7 Apr 2025
 08:57:45 +0000
From: Huan Tang <tanghuan@vivo.com>
To: huobean@gmail.com
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	beanhuo@micron.com,
	bvanassche@acm.org,
	ebiggers@google.com,
	keosung.park@samsung.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux@weissschuh.net,
	luhongfei@vivo.com,
	manivannan.sadhasivam@linaro.org,
	martin.petersen@oracle.com,
	minwoo.im@samsung.com,
	opensource.kernel@vivo.com,
	peter.wang@mediatek.com,
	quic_cang@quicinc.com,
	quic_mnaresh@quicinc.com,
	quic_nguyenb@quicinc.com,
	tanghuan@vivo.com,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH v8] ufs: core: Add WB buffer resize support
Date: Mon,  7 Apr 2025 16:57:37 +0800
Message-Id: <20250407085737.273-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <5e067f1eecb2098c9c2368dc8a2005c1567198b0.camel@gmail.com>
References: <5e067f1eecb2098c9c2368dc8a2005c1567198b0.camel@gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::18) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SEZPR06MB7002:EE_
X-MS-Office365-Filtering-Correlation-Id: 7656d552-e888-478f-6952-08dd75b2437d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|52116014|376014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/jpiNOE+zwr/4lwx9y9Cbif10kpxB8dGzUjjGaIGhZVB1b2H9BWJFQsfr5/M?=
 =?us-ascii?Q?A+hVvtcBjzjXRBn+qDL+RZAjzk2axxH3q91NAKLPW9cj71SNBHPX+XRB9XiV?=
 =?us-ascii?Q?J10SNgt/AWKSyNhcJdTvvCpH7DYzCm1O95qH5A2irPEuF7S/g9+83rwVLtmU?=
 =?us-ascii?Q?aaO3BMBDckUcIShBvawLd4twS8X8O5yatfIH559OcDiF+BkxZAUdqfXJyyht?=
 =?us-ascii?Q?zMS2jGlEvcribj8zcVY5v8aZH0hSsGcZ4igc8GLxzkklgdFhbvJvsR8PZ53i?=
 =?us-ascii?Q?y9fTas6GAYVcpQNPHVQhv714PqyX2ftdAQNYWLoXHIGPhCiHyRmUacVnaum5?=
 =?us-ascii?Q?5PRU8h6BG1B1+6MU8Qqe4WG957+9Sb2v2LalsZqpfnstrTYwEbI99O0PBxso?=
 =?us-ascii?Q?LmK0HjRX0zmYVtvmdIFgBsNf6xSI80Bx915l9jJhE9+w3gZCY4qH+lMrsu4x?=
 =?us-ascii?Q?cUuGd8mfKGH8r4QOjwM834BBH53Y1iCojgcjHsMs0ubG9iIQvpza/4AuRAwu?=
 =?us-ascii?Q?IOKC9WTkJexFK07iyXHW8AQVoqBEa9hCs+AvOPV6XMIhNg0Pie45BlFvYKbr?=
 =?us-ascii?Q?it3I1QDgHAz4F+P7Hz6YNllFE6tUsWGuLAYUTb3GgqxfjR1K7gBnanYRNFJQ?=
 =?us-ascii?Q?kHtAETW5ug30ipKInDcN96IUUQunvtHXTpchJYQxHUTug+YqY7/s5sv2tYQl?=
 =?us-ascii?Q?7texDR2YFUGiZkVad3YLbXXWxfOfnoIlsjj/tD0Acb207R0FY0ZtIhFPyaD9?=
 =?us-ascii?Q?+ruShN8LG2rtmzEEJJZ7t6oxvPBxcyndhALpAT3R6kHUbjtl/AIGUByBIDMV?=
 =?us-ascii?Q?gKEmEJ/1l5CMsfXjnQJ2nejlq4TnxnM/jfZeWKw24npWQgtPRI1JhOMhLYJR?=
 =?us-ascii?Q?oUSO31f4xHko4vXTbFkn4KQYYkef+GzXbMT+9HComBQR7RAg0A7Op2/T0msO?=
 =?us-ascii?Q?oObLhxMiNpmUK++TsOftjpNad0ZAELBmsnhTTv8TPS2AGnoDthVXyuqJDerP?=
 =?us-ascii?Q?bH8VRrMfSpoxOIic7UMzKaBaVIoXvEz1dlyk8q5/yJQio6GoX35LMNn4FUj0?=
 =?us-ascii?Q?6HvSCeWMEkCiK/BZUGSrAiBO3RPDgVdEk/XcCfZgL+Kpwx/Gl6stYbm50DKO?=
 =?us-ascii?Q?x+1f7e5KH0iC4i5OI4OVcK+1mbUFmcJZ4NGhexWoLluy6UEDthMADUVYjmCk?=
 =?us-ascii?Q?qMbThgJhNd2uWeqTXvfVe/Zi6cl2V7TQfWOZz8JX74PAAI6gcjhw50HB6JEL?=
 =?us-ascii?Q?vLS1pfZ8a0LvH5bTSinpQqw1xoGQytUErx2ncWSKZxq1dZgQUN6WNrUjsypF?=
 =?us-ascii?Q?+3pXysfFwF0q8qzMG9sRP9Eo54xjzXtmoIkPtqU5me2QbFQyj7D+BfLTwwr8?=
 =?us-ascii?Q?N7m7WH1ZvCGzuO3MLrcFl4ZO5XctFwSzhFvE+JBAuN9N5lYXUMsmx41FTeTk?=
 =?us-ascii?Q?yJpZ7huBca7CwtnT4r8GpP4zZPlAQqHU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(52116014)(376014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OxNrb0prcJ/SRXrpsghAv3SnzVRxkbyqTTGBetWOl41bPI4/F76tdFcd6mwY?=
 =?us-ascii?Q?5PCcn6zdTmnLV+fb6gqD4USQDb9AwKNwyUbAYDhUQSWXyrv3xnSwYYD7JyTC?=
 =?us-ascii?Q?gKBLZv8PMvaQi9EwsgjK2mjHWi/KxjjKYBPyZ4vzgAT+pNsHHJuXMuVQ0iK9?=
 =?us-ascii?Q?peVG8h78NRH4sieHDrmkYQedZZy2sE0Vuro7Bd5954B2cM61H05+tyaCgMJS?=
 =?us-ascii?Q?ZoNkZMVO6dNCwhQxM9JMM6obB+T6h/3Aipsk5lUVA88Rxn+3T2pP4udixP5J?=
 =?us-ascii?Q?2bln0xIgtOmx/nZU+zoskt1U4O+yH3isFAUxOljrjgDfEK27wzeDONvmsvTj?=
 =?us-ascii?Q?rB2ODNpnJURClkuwj7s73ENwmDSJ8bL8uW0xxHcBFFO0DyzQhsRk6H0vEi1h?=
 =?us-ascii?Q?Fl15AK8e9+ldPZg4DPv7Qn9tJ/IqtX8EHYF7ssq6+dvpl+ZlU2o6ULw0XAvJ?=
 =?us-ascii?Q?e8zc5I0ogimDVkETJOKx32uYfbQ5VAL7uMVRjikV3oBb4916p7pQkYYvz5LO?=
 =?us-ascii?Q?6PHqW10w6gifISsNe9rcTYz00hd1bKkZc4PnmU4shl1DI+bPAM/NimYaebR9?=
 =?us-ascii?Q?LVioY59z8Ua/3KJ/e+aQkf7DGOX7Gad2D62F7rV/UG1rKLUJoElRE5y/ynxl?=
 =?us-ascii?Q?0WlTTFBaJWaDCPtM6QCUqhfmZwuOkWD0WFuNUgI/MgHvPxkFcr2eMnhwxIea?=
 =?us-ascii?Q?WQIzJ0MxDreGQzGrNbHlfyowsK032FlukiwpPtS5ryEGUqp3JURtVIF1jrZb?=
 =?us-ascii?Q?1HzI9l82ZYzyJfGyPYlPg8ZuiI+ynxNt9lmfK07w+W5i5+7oK8rY6H83mkxo?=
 =?us-ascii?Q?Mu4NiKH3eC/Hp597vpa9mJhLLct5L09ynKo6/mYd3DykeMsfkHnZPcGNdoB7?=
 =?us-ascii?Q?L4T5xSTkdvtngwpn+9ukBtXWsJ6n204zFQFQ2G8TFmfxMMn3lFIqBY/8oOYA?=
 =?us-ascii?Q?W48SAFGf5/Biz66h01F/Nwz6Ne+e85Ei8pw0YaJ0EKpvkINI1wCwLL38h1Hb?=
 =?us-ascii?Q?v8Z/7W5wD47/t5Mh8v3VbBjmVVYUL1qr5RiopVtTz+X7XlpbezH8Q67NV7Me?=
 =?us-ascii?Q?anv+jy2pbHHNQ4CY58ucTikbna9wEu65sdEED2exPX9Eh0gTdJZg55v25f+m?=
 =?us-ascii?Q?9PoeGlkxUHb+RxcTyWhOLK1TAUoV5Z3fzlP4Ytxts2M7hle3ZuEcOaJiKBb8?=
 =?us-ascii?Q?Cvkcqf86IMXItuxiR9qaFAMahLCqJd3dCQq6LV0O7IWmhYdZTvi0ynzWlkVE?=
 =?us-ascii?Q?DG85AWVEuoMU+gyze+tyQwKiPfh7gcnPXXyqCFwmQZ+BGLbVBUIQhyFHMd7M?=
 =?us-ascii?Q?SPotJX7zQflE82420Y0soHAB5JlIOAFeIA4hI5KHm40x6VcU9rm4h8yC3CJ2?=
 =?us-ascii?Q?x2MtsQJm79HEXYupKA0zaUgOz0OHNmRZYcC/9S5RNykFstfMmfkVal5PAsVv?=
 =?us-ascii?Q?eOnCfUCFlgdxkArmMJYJKRF5l/OQ5lJERFceEgozdNgaUTeogVcQwUydDHpO?=
 =?us-ascii?Q?uMXeEQ3Hg5Egu0+zhViIZIVaJwvDA9W4aGCgGDoiw0Izen2YTdW6MTNfkypB?=
 =?us-ascii?Q?AafPi+dwuONIf7wPc76ZlVZ/QHrA4QHa+Pnpx6rj?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7656d552-e888-478f-6952-08dd75b2437d
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2025 08:57:45.6246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XXkW2tMCP+6/qX9HyNBfWBYYj5K/cspU84yJ8yajMbFwAaFhsQsDs30FMUU6v/wT+qyFAnseyMPudlIkVyGbVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB7002

> Typo: "gerneral_fail"  --> general_fail=0D
=0D
Bean sir,=0D
=0D
Thanks for you reply! =0D
fix done,please review:=0D
https://lore.kernel.org/all/20250407085143.173-1-tanghuan@vivo.com/=0D
