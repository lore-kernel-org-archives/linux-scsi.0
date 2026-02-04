Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028A73BB5A;
	Wed,  4 Feb 2026 03:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770175221; cv=fail; b=CVaNRkDWxw+ppmB2bNZcVI37ewIdOfzmj+b1CCccjf6DcaYGUg2evSr8DY8ypB2FudZ4Rpb8dmkwlgvpAEVmO2dY+OXazqoBxy9J5fKd5aKSp9eZfHYMxwqpfemtGDzJNvi0up4kj/x1JFI5Cvxltd+CMnsXZD9llLSiHk1xKJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770175221; c=relaxed/simple;
	bh=NrDOlwZUQ4IpqN1m6f4SLe9zLx9kBi+8Qf9bKCRB07g=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gFxVYUV3jDy8erEFiIxlTVziO+oIhGsd4kf5L+R4XOmiPinMF9+ujRBXMJVkDEoOsa5aw/yJsGwEoAm5WoT7g7rOwEVPa4jQG6SN8cs5cVsuQVYye/RKBpMq8K/atXYbXUmqdbLpgPF4jbOdZg28I8vD18EbKcZCSPcEyutN8qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fNMaqbaW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BWKCeaTf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fNMaqbaW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BWKCeaTf"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613IuEMI580141;
	Wed, 4 Feb 2026 03:19:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=P54A7QUjHJmdqw3A4M
	RBBEDMfPuiPILpc4mk0Kq7Vu0=; b=fNMaqbaWZrN80/bGUAaVbr0LazXn/5Uimu
	masqtNgviEb4c0B2TRCd2DeDP2eQg8YqXn5iiX9ADKQ2Io3O1BCSPEzQtbKIVdoX
	H0LLRVxo73LwBAs3Y0T9Bu0fM66bQGeFR9Wse3cTN3+x/Ca7gnEmKx1M2lx3IK8x
	1eL+HLp20K/Aj67Bm7XPxPc6YbIS+et+gbyXSgcpWDLf8BNn7XKCp9G64X+a8VuD
	meoEg0Rh6Yo3usn95l5GnIhL3++vCrRBsECpd6nAEo9/zOFbH8mzbXADXHdP6Fwo
	1ZmdGQGP6Qqf2T9AGIdb+5btOYbSp1l88TSOx5Xko2OZLNJKTt+w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3k5g11pf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:19:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61430IbJ026046;
	Wed, 4 Feb 2026 03:19:10 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010063.outbound.protection.outlook.com [40.93.198.63])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c2579er07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:19:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jR61EiM13gZ5kY5MK+8DCSBricGP2+j5zgfTbwrT3DdCRVmwQ8QtagmpuNbD1Lk008ucMzX2x3AD08dT5ZNVeklvZYWWiTEQ5fALsoRjxGD5iI8IuxEAJoi8YFHQsR6K95BytmG/AeJoa7pNXjxHEV0UndV6bPOezBv+gGtFsQCuRco1jU3eB7gUnHudPM1h52kTsBLG4KGN7A8oZREpYKPFIldY4iP1Y9KaQdkZS+NDfYZnQt7LPuHKda6B+uiqpu8gugQnKXGUeDxc8juqgpDPkcv9oaFkZ8mMztP7gdbLwC3DuKuVfxJXGy00KCz0NGYJpfrvrEiNLeKqkWjlCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P54A7QUjHJmdqw3A4MRBBEDMfPuiPILpc4mk0Kq7Vu0=;
 b=I2y4ddn5X5WV1y5xrJNzbLwnRGcoAWuGRCFvg8TYdTGrUShbVZfi795hfEiIM0RryjKoDFnLJiBmmo6RjG4r0zXNuu70mLI56CEdoRtFipjNvg4X0SlmGmxlUilSUskMjZ2ivYdGpJOS3ETV8HcpxUsWF+2f2qTfojSvDm4fJS67hh0KxMJHzK/fUNwR4s0h6wdixI86yNZyOzRpbpf4Dc6GMszLKQnrsjX6Izj1IEiFuwH305AFCpSrQNDPW10ui7AiUAzJFTYb5dof8UoX/VdWRpPwn1AGKHgMgqZaqxrQ5tik7DQfCasMTV8C3D3ju2Lj4FFproNEqOLg4Nc44A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P54A7QUjHJmdqw3A4MRBBEDMfPuiPILpc4mk0Kq7Vu0=;
 b=BWKCeaTfSKVFYTSKExRN2bgq+lltyZqvFhIrK9aoxyy3AFZIl4cB5mOt0ti8Nv6Bx+6dz45enS2u68QXxEyNa5g1l/dse6/oe0vdMslWuUdf3MaF/0K8NDEJ+i+8TWrFL5ikux3o5MHusFsjZ0c3uZuDgNzsRa423/3eEkaR6cU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN2PR10MB4366.namprd10.prod.outlook.com (2603:10b6:208:1dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 03:19:07 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 03:19:07 +0000
To: Thomas Yen <thomasyen@google.com>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        Stable Tree <stable@vger.kernel.org>,
        Alim Akhtar
 <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van
 Assche <bvanassche@acm.org>,
        Peter Wang <peter.wang@mediatek.com>, Bean
 Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao
 D. Nguyen" <quic_nguyenb@quicinc.com>,
        Subhash Jadavani
 <subhashj@codeaurora.org>,
        Dolev Raviv <draviv@codeaurora.org>,
        Sujit
 Reddy Thumma <sthumma@codeaurora.org>,
        "open list:UNIVERSAL FLASH STORAGE
 HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>,
        open list
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/1] scsi: ufs: core: Flush exception handling work
 when RPM level is zero
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260129165156.956601-1-thomasyen@google.com> (Thomas Yen's
	message of "Fri, 30 Jan 2026 00:51:51 +0800")
Organization: Oracle Corporation
Message-ID: <yq1v7gdnqm8.fsf@ca-mkp.ca.oracle.com>
References: <20260129165156.956601-1-thomasyen@google.com>
Date: Tue, 03 Feb 2026 22:19:05 -0500
Content-Type: text/plain
X-ClientProxiedBy: CH5PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:610:1f4::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN2PR10MB4366:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d717b56-cb62-4686-410e-08de639c27f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ji+CpwaRw6IjcS6EVhzxAD1D3tv25AEN8wkKb8v2tuLH7gwvIcQcRAFK3H7P?=
 =?us-ascii?Q?LE9nEvikaH/pKd4PaXEa90olNPnhhAhvDNlr1REvnDzbS7dskIWjPf5DMCqX?=
 =?us-ascii?Q?HCeg1/AGZRonFfLMnaCtaWo4uNIX1g20S78IkcKZ45Q6pH5arT+wSBp+QDuF?=
 =?us-ascii?Q?umVZKgsMMXeNy21DIDFVhEfzWtmYDka7tSsJdPNpH6kND2yf47K23TrrtGai?=
 =?us-ascii?Q?MIownxrndZBs6KjRQAB9641pEZhla1czukZRvfbegq6hcy0TrF33g0rkYtAR?=
 =?us-ascii?Q?0D9Fe0hSK68wsHFnxxvoMEgjKvb8qvx2LI+67xaH8vz9XfYBDPZ2GtY7OvTA?=
 =?us-ascii?Q?KQW4aqNYF4VfcRr0E7ZCXRMw+fypMLrW/MoQ+0A/WiREeUElwLyu6AYkl5YI?=
 =?us-ascii?Q?tp1qvA0tyf/w4tq5Afc9+UEUI5yOBSfcf6wSa6Aag+zKim+WXmja169vUSrf?=
 =?us-ascii?Q?lQPG+i0EqTo/FXywk1h67hvw8zqaB3GmMz85uAt+3xY6mXiT/IDBHJpVO7CG?=
 =?us-ascii?Q?IXDHTqrPIzsD+GxhIjDewTDFScCt4H/DpUfW/3x4cMVGD3ZJxxfk1A3yH/I6?=
 =?us-ascii?Q?S3sxjCfDpFvcvWc5JiE7GsS6T1utPUkfEWeksPuxnT+0tRdYQwdNYzOAiwE2?=
 =?us-ascii?Q?mruifg4KF46Lt1EZPeSKK4JhaYyPH3NON2R5ksMl5HwLARNRoP8dSUOogeV0?=
 =?us-ascii?Q?jQjP3Ccxxj8RWJkwV1IAXKUsxxIZzemKf+sgv7I3icqxYDNw45uyCP6pgWRh?=
 =?us-ascii?Q?1dW72fxbRy8J1OU9wJQ0+/ee2Z6PAlbyWAptFY3/pEHqH8CoOyBBuCEXtris?=
 =?us-ascii?Q?xS2VvnPulYExFRs0kIX3uD9RRH8u6JIuHOtAkNNTJNmyR4YBWYzkeRgLXooH?=
 =?us-ascii?Q?h+KIW2b2FLFARquKTXSTl4+yX8ZSPl5oim6IuKfIs73j2kOubxm/0QRhKrdz?=
 =?us-ascii?Q?iOCCy5UEWnXmFTTPh86CioCbE6ToThAl1ADu1e4iWJQVO5TAXlJ8UwPLx7Bi?=
 =?us-ascii?Q?mIsEBKqZtVjisuMwD9mR41ywiDltKVzq9WPXm03pgkDJX/eaHDzGdk5gVYY8?=
 =?us-ascii?Q?fi0DFDQ8Ij30ElWIGqXuvEVI3cdNWALai1kBfa4S24FjtuyHCPeMQSwnvBKG?=
 =?us-ascii?Q?Yf/qquiD/VlbW8FuCYoqJOb7ZHmxyHogBbiKZYwlMLWYJxeHX14PIcwvpbwv?=
 =?us-ascii?Q?XPsUrG6vDNb61zqCgWuxNvFAf7YvQfOEO8HfjdZjbrvJJqDHFU6HUfWPOaHd?=
 =?us-ascii?Q?+X1hHswpm5N/cbdt6eyEJ7WDndC6LyEfeQeA9xw0VSJO1HyZPu43ij+mqr/y?=
 =?us-ascii?Q?ucARBAklx1NDsF7yCAjax8bP+h9JTinv6Dz025u4CrayxMliqa/kzFxvkqvh?=
 =?us-ascii?Q?BfB93RdE+iYD/lSKr25yXVVeKx7Lc+hlDUoM4rhphERGXRJnO8FKFmxsrUGA?=
 =?us-ascii?Q?UZUAFxp1X7Ldm1rHFJ3XjEyWQOUFAeZOaP15hghsGHgB7nIbaZxBeuxFogHO?=
 =?us-ascii?Q?8amQvwa/6Is5thpHdpuSAqJQ5hakVECRDC36eSZFR1yeHWrz5VVI2e8T8MqE?=
 =?us-ascii?Q?VvGMZhRWLVRW+iZo/Fs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G3yj6cuy0IeVoQhw0vRCEGH1+Gk2AU4linilemtYjC0zFDTn3mVGJWthHRY+?=
 =?us-ascii?Q?pn1YHcj8fwEgYDVLOCP2r/ZG3s3dzHjrQiL4ni5Sa6y8qWWqEjM6jGUgWaJI?=
 =?us-ascii?Q?S5XSaPA4Q506rqgA27xYXbaTU2sbekZsaDzUX+rDmeBeheY0bPX+F/sQE7ZR?=
 =?us-ascii?Q?/HcPkPVxx74M4Xy7ZRFNk8W7N9VzL9QQklUymU8JxJ0OPAmVZS2xASokG4AI?=
 =?us-ascii?Q?xRmYSlLRnMud5lnymz4ILfmhloAjHCIRojJJFmtd6PHiDepFeZ8OLNWo2sss?=
 =?us-ascii?Q?66jgmKSNFSRd/yg+dEmIQ1pWoImeSFx31HE6JsqY8sxAE2KdQ7DqdUtlz+QG?=
 =?us-ascii?Q?7+MX8F+pccFPn0bu7++WVBo4LzYh/uNoddireCnYyVOL7MnkZRV7WU24xQrG?=
 =?us-ascii?Q?Jq/vvQknrjZH9AYeujLxjDq6a5PXfCcI+T2ZmeJoJTQKFOnzz9eDfmCmvgA5?=
 =?us-ascii?Q?3HmZcoCD4tCeyIlltSPIj+wH0Fdw5x7rkOFsapLP3t+NxCJdGKGpOP3ChpXS?=
 =?us-ascii?Q?FLmrfvhYrSYX6tW09quIIaVXDCiYzU+pE3CN7orahcoGdRWg7mLeK0B2agF+?=
 =?us-ascii?Q?2xkU0/dG6o+37HuqH1HH9j9mJSOe56XYniSMC2ENWWuhXOqCekSWXvaTpe+a?=
 =?us-ascii?Q?GMJ+bEPrePKBRY7YI7P6GnRTY7jVXk2vOx8eEE6O4N48zOklRhTDTxNeilNH?=
 =?us-ascii?Q?0wb2gOFh9QGnFlRfD0hvOnE7x8yzWnS1CYPwfq9gjUhLU4W+T+Yqt9Ci39jq?=
 =?us-ascii?Q?5K5U4+cjbW0C+gsxUyIaQHU0BLHJ7MGJJklC5ti/lUoULDRUQKA4bb8sYWY9?=
 =?us-ascii?Q?JPrVZLs0ylhvEznEloN8WnaEBcapR2rPRBbZnAgTz5pBjcl6nlGP011pNnyL?=
 =?us-ascii?Q?cjFvwAq+KTSNJfh8KrPmwq4HirMBmbWAjpdMxEb4Cl0ckp5n6BezlXN+v7sz?=
 =?us-ascii?Q?YG7pRXVQxN7J8cEDCqVoBSOvDSc4vhgh2tj0QWhkmGDS6ru9+dGZeJpMyRyn?=
 =?us-ascii?Q?9xh9EdAR61rgqy4j5s/uFy1rojpwK/z9vgjr55GC7P+/fBBCc1lTNc44rYlg?=
 =?us-ascii?Q?DwYscc2GtdiqZWMuMNpK0kqys+nt2p03/A6h4YxMYPjPySkBd+eOgaBbZr3a?=
 =?us-ascii?Q?N5aDfFhzQEmti+r0OBz1stShYinwJeZrF/naL69Tzs1rMceermdqOQO6qAYr?=
 =?us-ascii?Q?vfU9GALXgMgAjA9U2jrm1TqJPZr4klyoZuS82k4LxFG/4FvzQFcsWeCHCe8b?=
 =?us-ascii?Q?zIyA2gFOnoRC5odtrFc/YRG5UyeULkMBORZPYp5bqUFnCmxRAo6fBrOzatu7?=
 =?us-ascii?Q?vrOr2PeHbExnJNLs76dAZQar7Q9epViXjNI9tU/+EzPHAR6CpK8wipDPxaKQ?=
 =?us-ascii?Q?CctEAy9Xx30+45TvwbibeIL6ZBURdE3LaqInHu2aw6qa67Wf8uwZxAr7WTIL?=
 =?us-ascii?Q?zy6PB/1QUyGMUsWL8qkGjoeH1M68jX5HHpIT10nKbbGDlbAm/VAsoTkmUDxa?=
 =?us-ascii?Q?PM80eXeCettl+maza+lo+9u/NhSeJanPMRUcSfJayfgTCi9jO227BlgcEsS2?=
 =?us-ascii?Q?8Zk9E4rRuK5kakbU6Bh9xrGCKPxVq+lRDTnkyzxTzdvh0zyNSwF6eQzjRUaR?=
 =?us-ascii?Q?FQ9/GMB1ucnTqmNbWtvonNYXr9yC/0MbiJjevKrPw+MglSip81ptQkBe24Tm?=
 =?us-ascii?Q?Bj6F4fshVtPoWrf8xczzXtj7mOKPbLtQGYhxVVs3QGz0XA803rLRXqJaTgVN?=
 =?us-ascii?Q?kE6f5sqtU/Htbkor6axmif7sff7Ncws=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pxg9D0IUC7Xc+M4WXI6qbcPve3i3avGCK+or2nfPriCLH5NMb4snbh7lwokPilokKoVnx8OIdxdWcMgqIjcW7MSEbdXfkKZJKMMP2DI9olwBRV03LHbk/VdmzdddP6Pad3qhh203LCNSN7ZR+tmm0s8wy/Lm7O5X7nhg/zDeyhtHXcEUWYRgfjE446l1cOxowXcIKtih1PGUZYEKz1ESDRTekLYxUNGPC12IcvN+1grcd/n2m24pd2Qf1abxcP2ZrleHQPUw6VWcwDtVdjd+ksK+jcDiJwTa4+HNQ18A3FQqAFNft+Z+LnVGrthTVVYKEE0erUZ0295zDBoR2wdtg8Kv3htCmg05NjWY4gCfHPBYQ8qVjDBTyRBiI5YehfLGsNUrdIjUpFw/pyzegoEBpin0Ajoekycg5cr00g+IiwNqyEFZ5NRo5bfzm23wJtD/JyAniuj3B+m2HDB0TYC9cTHpsyKgZKg0Mqgkp/k7TT3ap7RqWGDEtndvPL+VfzIbz7Kl99Hs+hKTv143pn3r/JLZV6ZbnEUThU4vSbVJqhIrerL41gcXKI2j1yrQx/mQocbdkPY210DnBLeaIFMeIaSObszLfrFcBdUj7S+uvYw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d717b56-cb62-4686-410e-08de639c27f1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 03:19:07.1531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TqnJ95k5rwDEAojpkM6+KRo2+Qw78oWUA5gQ7ydGSE2cZ08FZwAZBCndNfcK1AkHDDR5OShAtR3OX3DM/yF7UZ2MQE1lklncUxIubHKby/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4366
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_07,2026-02-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602040021
X-Authority-Analysis: v=2.4 cv=Jor8bc4C c=1 sm=1 tr=0 ts=6982baaf b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=XeYMb2X_t0g3pPXhErEA:9 cc=ntf
 awl=host:13644
X-Proofpoint-ORIG-GUID: cQa1bRC5q3VM2EbDhGVhY9i2LwZsCfzu
X-Proofpoint-GUID: cQa1bRC5q3VM2EbDhGVhY9i2LwZsCfzu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDAyMCBTYWx0ZWRfX3usyMsUKASq/
 Qm0nOsdi2HnLK/wDftbeYPYNr3Ec2vVJv2VkjEd3HFeygJnFZOHuoP+HJN7dqCZ52yJ0FWblhGr
 lWNX9x3+vHYJ33tv9ae6X/UAjQdcO6L7rWpeBLDTXPoA/nCToRu0/Ghlyfz6Skl+rmXhqAgKhV4
 tNnXCuRucJTLfePqb55ziWtcUhPsi+lVljSrn3EbjYLLW2uWjkHkEeDZ9ZfPHLXl638YzvG5oAC
 xy9n//iimgSrWr3F23hdqdQq0mXpWxzuX8mBkdYRsATUgnSFWdbtD0f4nsrjpRw+pVJkdzNZnDI
 8x6wp4kXhOw5BMBCawvnbJVJ8pawMoftCaLENOip2shUwGI0mktK8mzjYyaB2c+bsVccKhlf0WP
 rhkY3UuM60UFPk7Nz1faFWHdJAGDEyqc2lJzvLt0FNE207im92mMn3vmF9/kc4vue3BJAh5Nfw/
 hfYranQjabeKUrkFSJ5W/F6Koz9olGShBGdKAWEw=


Thomas,

> Ensure that the exception event handling work is explicitly flushed
> during suspend when the runtime power management level is set to
> UFS_PM_LVL_0.

Replied to the wrong mail, I applied v4. Thanks!

-- 
Martin K. Petersen
