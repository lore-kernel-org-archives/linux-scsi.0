Received: from HK3PR03CU002.outbound.protection.outlook.com (mail-eastasiaazon11011067.outbound.protection.outlook.com [52.101.129.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C56123A9;
	Wed, 21 May 2025 14:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.129.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747837961; cv=fail; b=XHRJVSPfFC+G26DiPtD//4nuxfdXZKJl0pQWFH6y6CFh6k0DxlBl9ZP/XEpHyh9kz+gya2Dj/htypjuGYuRzKQFHPDgmjzNaylh6Qyxt+N/k2Ugt7j3cl7sJo9BoXfjB76CgpOxJUuzVq9HNt+KcxHrqB8TzDU/wQfq+V8WVmmY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747837961; c=relaxed/simple;
	bh=dQLLIeCtPJq8YUPudZ1KSxU9zrvNywqE1jcickqVqyk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CmsDA/bCpf5e4hEeHrJOBRp+fahS0TqfvoTsYEgfSGcviJSe/cQA3wKZaQ2el+Xk7HmiHO6COaW8mM1744ZpvnbokjTTCnC1xGMEmPuqCaMdR6qj2QKQy0NQMg4cocDXAr7+DUEig7ytojxejwaoVhU1WH7STq1XBJMXQg+/Wxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=S8fc060m; arc=fail smtp.client-ip=52.101.129.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="S8fc060m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yaUJV2q96iUXs6xzxe3GxnkCh+S7MMLB8pzYD0eq9WewTtCBLHIh88wes4hx3fGeBlz8N+YvBdlicqD+8FKS6tlKHZ16hEcXuetfz3nZktX7/2n/AVNp5F6tTh8jt2mz4XnbDk3JZ5Y2lTxxIANd91ZMIxhEkkUNGgJwDgiV8ZyHZ7gLIhFhA8fAiP5M0AqXvqkuXK4tpfPDpSzLJl6sWUFvp/Rdl/B5S1AZULf672NyLb/pKPLcgnOjNmi3nZ21IySAaYIXnVSer7isKo8skqOEJA5BP1MngCZXEDrxRhEWbbqdUyer2BExlgUlKK7Jfbn/pJOu2ropdcRxEs2rJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VZIFLLfgij7V6rfRD5p6qdomwmU7bV8vr0xGZLBi/u8=;
 b=xLTH7xncnwjHvK7d8F4Q+yvPJESBxYi2dGLQm2c8l9+H+vJE+Y3aq4Jc5LVMw713ZdcmDiYSaBhqspjcNV0NHh6HlHnb4HXnN4+XqxmElshWIlLwffQTBMI7p7qZHmSajU7dbD2cLgBpXzlz5kBqZIALyz3QLeNPA3sGpD+of+YK++wOjvck7UDGFBKJ24BEg3Luvsx7DP5a61WaWerMwzgNGUIWkXRjs2iQlI8TA3Nnj8cfejSJOoCrvRWNqH+O9f1HS1kRGS/NKT9y2xxUWcU+Peytg4aDXIIkMGZSSbDSWjqgU7WHKWQcaF1hXekwldgGa59XwdumqjwUgcOHog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZIFLLfgij7V6rfRD5p6qdomwmU7bV8vr0xGZLBi/u8=;
 b=S8fc060mHX6/SwoQkKa+FxjWYOL399UBAL/NH2oCem1Sg1XG3oc5cl3HjBkukxfg6ML6R5LLdW65RA91PH7C7d1XqW2ow136TvxR9qTD8NCMFIEV6bn/fABVNKHid1lebfWr/AHDE5ybPVGxhBSw377k8IYcDRnvXUrtNmC1ybhcwgoJWxhwrBGOLXdDbqcXN3Uw5dhzjYMWwNGN8OWPaP9CFzPF4S0N3iEjIDgXhD8KmyJ9gOmkLFnn0eC/DHh0bVH10bnRyjetpUOCDWps8Aoal79VHoyfFU0uNrkDI1SAfaoB3NEBiwLdG2J+rf53PW0aT7oEZTWssdsou8itjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by TYSPR06MB6605.apcprd06.prod.outlook.com (2603:1096:400:47d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Wed, 21 May
 2025 14:32:33 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%7]) with mapi id 15.20.8769.019; Wed, 21 May 2025
 14:32:33 +0000
From: Huan Tang <tanghuan@vivo.com>
To: bvanassche@acm.org,
	huobean@gmail.com
Cc: James.Bottomley@HansenPartnership.com,
	alim.akhtar@samsung.com,
	angelogioacchino.delregno@collabora.com,
	avri.altman@wdc.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	luhongfei@vivo.com,
	manivannan.sadhasivam@linaro.org,
	martin.petersen@oracle.com,
	matthias.bgg@gmail.com,
	opensource.kernel@vivo.com,
	peter.wang@mediatek.com,
	quic_nguyenb@quicinc.com,
	tanghuan@vivo.com,
	wenxing.cheng@vivo.com
Subject: Re: [PATCH v5] ufs: core: Add HID support
Date: Wed, 21 May 2025 22:32:24 +0800
Message-Id: <20250521143224.587-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <b0ec5b8a-b303-4e5b-bca9-4524eba9fa31@acm.org>
References: <b0ec5b8a-b303-4e5b-bca9-4524eba9fa31@acm.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0058.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::9) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|TYSPR06MB6605:EE_
X-MS-Office365-Filtering-Correlation-Id: f73bd152-1449-4204-279c-08dd987452c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oyjKfeECeq9mInhn4fjSJ5tnNQDfBvD8ltp77y3orjUisjSgoRbcOK9d57Zk?=
 =?us-ascii?Q?49g89XXb2F3VAvdaopwvjstKFcpPLDTxo1d4n8r/FBWvlZ5N4+xr8XRBghEr?=
 =?us-ascii?Q?xMpUA3wdFbGp5r2sYwp069rRAiJp8GQXTaAfbyN8YoRS6TEeCuLL4pCQMt8b?=
 =?us-ascii?Q?GWkhDaR583g/Hu5fH7ebhGbRWJNbAasrkBFZHRAr/v4jJvmlExxSL7C5dZJ5?=
 =?us-ascii?Q?vAU2QiDN9qUUB2n8PglrIGNpGT9Kjlztd35gS31Oc3J5wP7vX5X1hnRVj38f?=
 =?us-ascii?Q?DrKIPgNtPZ+KJpHP4C+NHxRfkq1n9RkyKyzZOkb358D3vcubodXMeV9OdD7J?=
 =?us-ascii?Q?wyB5qnDE7WEJCev39fpKPJ8mVXw87Bc4pUMzBVjK8mJI7oe44OntWEmt2usi?=
 =?us-ascii?Q?7hzzix3boWcYjn8vKyCV/8niKoio9XWwONlb9yJ8fevlDs2ZQEVhkf/ZGbfO?=
 =?us-ascii?Q?Cb88dThcjPQCokALRyD/kkSv2S8yXXiZg2Flc4uMMGT/NfK7IQyDaYlK+OrY?=
 =?us-ascii?Q?G0rqOcGh3DPzgDJ6wsnA15M+HCyzXsxnn+ZGriLI2WvxRboBLrftm+rFWwZ8?=
 =?us-ascii?Q?bF+HaiG43l3AhylWhfNSx9ucRCj4rzT4X0HC9NLyXANYLs8brjOLqoQI+7/s?=
 =?us-ascii?Q?z7/Cw88Sw1OS6FmsLVS5Zl0ThF0lnrsIVrm/jAAthGIMMx0y6RVbwYUf+8Yf?=
 =?us-ascii?Q?tP+nW3Dr1DhHlFi87oLbJ0n64JW1Fng20RlAfWIcRbQfXx+jk+U9/+Zo0K+j?=
 =?us-ascii?Q?ZB33OlE8QNXAB8e4eZ0qgRjRdfJovOPgwkn+LZgDXJ4h64FqaCE0RxprEc2Z?=
 =?us-ascii?Q?ZG1wwB1rKAZcexy6XZEhkInMWipEUAY9sNOA1g56XbKAxnteg+EnQKRwWtgl?=
 =?us-ascii?Q?m2VbQATJrQV7VZHLh1Bh7hYkYFvlYWWXHXjFX2ayqey4tBDWr4SIFq20Pofl?=
 =?us-ascii?Q?8ZTlu9fSP4eARSW+TQlHj4eulvCOU50LCTgtxbDlZ67CKQPryLPFsaG/d7yI?=
 =?us-ascii?Q?CmF6VM4ATKS40IXvj01eHuxW5rp8Mn+uF7Gbzw35KLmPpMg6+am+0t/n1ITp?=
 =?us-ascii?Q?Ax9fTCTseVHWpU2lCv87AypYhmVaZEsGkMNd2/0SpM0shvjcmSMWzVDgsvzB?=
 =?us-ascii?Q?y1c18RUfU6pa1L9DeVnKiouKPCrUrFAwb2nLUWAchfBEU1F7qbXVWxTzzgWE?=
 =?us-ascii?Q?PDp1sVhucsFuMj2xo4NC3OK6cwtLzYkMDpk9k46swbRZi7kt81fP1USqYMuY?=
 =?us-ascii?Q?qbyMWt6l26QLB4Ebxi4RCi1kFwI8QBXa4vR3hlZLeZGyR3a8HuEDale7nrT5?=
 =?us-ascii?Q?MPqWxZ0RixWTTlGfOacVXCwlSkAhIPE9tJ0u0WYoSqMPn1phQWHmgXY3rG2l?=
 =?us-ascii?Q?Pv/drbwWLaou/+XGe+WCyQTCZGxA78y6dfE3XIfLLbEE81d13aj0817g/Nl8?=
 =?us-ascii?Q?0A9yrky+5bcPtPGBabdo5h8ndwCB6yoZuvxWibaeNFpu3P6e7NvioQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MxD4klXE5HWuo5BhwdyF2ogRB08+OqnJM2h+AuK4vhchHcm0EPP4Fl+KrCmX?=
 =?us-ascii?Q?Ezl8pWZqb+JUky94MNxfprycRyNdDT4LfXbS27scqL6aXYl54Rfp3EMY5V1v?=
 =?us-ascii?Q?fDDEBCa+3DpDzzwq2d8QLiQ6sQe4dfY+P7a7eYlT+8uEET6TfjfloPGL+8Du?=
 =?us-ascii?Q?D82K8OUG9fv4DiINhE+MSiYI9SjgK6TXvJ33k0ZXqu+IqljA9/HyLBnmaeza?=
 =?us-ascii?Q?ObQefkwqdFJCQMPVwNSRvPCQicBZ0N8phFMnK1/3bP3SkCEviZjuUkhdpt0e?=
 =?us-ascii?Q?eyQUMhQgCwFpCkOgEx5gpJmQa5Z4UVKhpP3lqI5IDU4a+FFyZWge8FFUXji3?=
 =?us-ascii?Q?MQ9K2ykk0MtK/KTGDDc122qhgxBT9MVu6mmqZOeRljDwLaaPw7jM1JUjybYa?=
 =?us-ascii?Q?BenotjImh855guXhwtwZdn5fhyCDkNd2en2f8zcmp4c0lx3T4bjJANMS93O2?=
 =?us-ascii?Q?DyH3SeUAb5Wt2gm3496TDJH8LvsLIJMG1Or/KBV+arhzBR6uMsYLUu42+XRK?=
 =?us-ascii?Q?fJy1L6E+5ELupesjxZpyyiHvcS7uERaSOAv3CkjnizsjO3eni1bbZVLdqKLm?=
 =?us-ascii?Q?aSyld7Y+6ZzNK8JItYJffhlugylMfsnsJHVr60U2/6fy8MlO3EZQLzjGKw/i?=
 =?us-ascii?Q?hzRMPecNMvHL7Fasd+Rxl+A8oeiHGuCZu5xuR387GWdXK3WY960zYOOtIZj+?=
 =?us-ascii?Q?t3TS01O+gilQITz2A38ssjQZk+VxW5HRV6ubSscBDGpPSK3xPdX8i66Iqwdv?=
 =?us-ascii?Q?jc9ukl0p1eK2r3T1huQp/Iq9Bt7AKQeRqET6oQOW/6Dc0zRoeScuw7GImo2U?=
 =?us-ascii?Q?skhW93YxQKvLJWCbvywoSlUl9/SykwdzibfMN1Yl/6oXS9dtP7ee4MCj0rwO?=
 =?us-ascii?Q?4mrImS10Nfd9LLZHVRbssilmXZ5PEu9CvdZq1IpKLlSMtB48I+/H8g0cxPVZ?=
 =?us-ascii?Q?ZftDyCQ2zEZU7EF29VBkyNXYjkNkgVYY9N5LTv147osnwh9ppwdA05NTp3Ex?=
 =?us-ascii?Q?vFw5OdS0nLsW3LWpan7evEPHZ6pg3bETQHTm02AtpUSFtLlmI5GNVmQh2Ym2?=
 =?us-ascii?Q?uOE1vfoi6tNZogn+s6Rk68v+M8PTosmXmg9Q/4TME+HawRz9xQ7kDVQanh5w?=
 =?us-ascii?Q?yWGBvboxQGIQnzy+KCeVZKWUTUQwCQY+gdRp+3OofzJYdJpiEWuS6h2FJTxB?=
 =?us-ascii?Q?aVRW68ryMmcCE1StnfbJTln9KAbJdCi/gJZA5O08jOhpLr/NJpI0jrJnkgDC?=
 =?us-ascii?Q?TsM+3T+vNYzZnFQtMqAeHQRrtlGcA1rfQNNydFDuX5F8d2hCk9Ed6w0SW4eh?=
 =?us-ascii?Q?tsaQPRffBzw/v2hhuNjKaCrNUq/H8aBWLaRcXaj085vXU99rZ1ImqyXa7J03?=
 =?us-ascii?Q?/CEFCUnio+rQzTnvF5UI9qP0jeexK7MAmvydBb93ps2Dr9ebxSBacK082kT9?=
 =?us-ascii?Q?aPSsaQHgxzH0HCMiHZhl+Fl8U1RZYc1UN24x+JSZXgwsf/Ku/Wlm1y95gUxx?=
 =?us-ascii?Q?ciLfT19F453eCLkms0OnywZb7GGieZo8Ud9YzuVqQ5vRHpV5O33BIkTtGi48?=
 =?us-ascii?Q?y/cNscJDfQm559lD+G+uUuh9/CalAI7tBY7Xfh1z?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f73bd152-1449-4204-279c-08dd987452c7
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 14:32:33.0771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bdpx30Oo1pyndPcDlQMt4/uJOPHektn/Ckpw8yBfVGgfUvWzQUBwiYjlFUHqu5PkLzmIKpwRGFDhV/kZBGdmbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR06MB6605

>>> +static const char *ufs_hid_state_to_string(enum ufs_hid_state state)=0D
>>> +{=0D
>>> +       switch (state) {=0D
>>> +       case HID_IDLE:=0D
>>> +               return "idle";=0D
>>> +       case ANALYSIS_IN_PROGRESS:=0D
>>> +               return "analysis_in_progress";=0D
>>> +       case DEFRAG_REQUIRED:=0D
>>> +               return "defrag_required";=0D
>>> +       case DEFRAG_IN_PROGRESS:=0D
>>> +               return "defrag_in_progress";=0D
>>> +       case DEFRAG_COMPLETED:=0D
>>> +               return "defrag_completed";=0D
>>> +       case DEFRAG_NOT_REQUIRED:=0D
>>> +               return "defrag_not_required";=0D
>>> +       default:=0D
>>> +               return "unknown";=0D
>>> +       }=0D
>>> +}=0D
>>=0D
>>The enum ufs_hid_state values are contiguous and start from 0, maybe chan=
ge switch-state to :=0D
>>=0D
>>#define NUM_UFS_HID_STATES 6=0D
>>static const char *ufs_hid_states[NUM_UFS_HID_STATES] =3D {=0D
>>     "idle",=0D
>>      "analysis_in_progress",=0D
>>      "defrag_required",=0D
>>      "defrag_in_progress",=0D
>>      "defrag_completed",=0D
>>      "defrag_not_required"=0D
>> };=0D
=0D
> If this change is made, please use the designated initializer syntax=0D
> ([label] =3D "text"). This will make it easier to verify that the=0D
> enumeration labels and the strings match.=0D
=0D
Hi bart and bean sir,=0D
=0D
Thank you for your comments and guidance=EF=BC=81=0D
=0D
What do you think of the following changes?=0D
=0D
ufs.h=0D
 +/* bHIDState attribute values */                                         =
      =0D
 +enum ufs_hid_state {                                                     =
      =0D
 +       HID_IDLE                =3D 0,                                    =
        =0D
 +       ANALYSIS_IN_PROGRESS    =3D 1,                                    =
        =0D
 +       DEFRAG_REQUIRED         =3D 2,                                    =
        =0D
 +       DEFRAG_IN_PROGRESS      =3D 3,                                    =
        =0D
 +       DEFRAG_COMPLETED        =3D 4,                                    =
        =0D
 +       DEFRAG_NOT_REQUIRED     =3D 5,                                    =
        =0D
 +       NUM_UFS_HID_STATES      =3D 6,                                    =
        =0D
 +}; =0D
=0D
ufs-sysfs.c=0D
 +static const char * const ufs_hid_states[] =3D {                         =
        =0D
 +       [HID_IDLE]              =3D "idle",                               =
        =0D
 +       [ANALYSIS_IN_PROGRESS]  =3D "analysis_in_progress",               =
        =0D
 +       [DEFRAG_REQUIRED]       =3D "defrag_required",                    =
        =0D
 +       [DEFRAG_IN_PROGRESS]    =3D "defrag_in_progress",                 =
        =0D
 +       [DEFRAG_COMPLETED]      =3D "defrag_completed",                   =
        =0D
 +       [DEFRAG_NOT_REQUIRED]   =3D "defrag_not_required",                =
        =0D
 +};                                                                       =
      =0D
 +                                                                         =
      =0D
 +static const char *ufs_hid_state_to_string(enum ufs_hid_state state)     =
      =0D
 +{                                                                        =
      =0D
 +       if (state < NUM_UFS_HID_STATES)                                   =
      =0D
 +               return ufs_hid_states[state];                             =
      =0D
 +                                                                         =
      =0D
 +       return "unknown";                                                 =
      =0D
 +} =0D
=0D
...=0D
=0D
+static ssize_t state_show(struct device *dev,=0D
+		struct device_attribute *attr, char *buf)=0D
+{=0D
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);=0D
+	u32 value;=0D
+	int ret;=0D
+=0D
+	ret =3D hid_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,=0D
+			QUERY_ATTR_IDN_HID_STATE, &value);=0D
+	if (ret)=0D
+		return ret;=0D
+=0D
+	return sysfs_emit(buf, "%s\n", ufs_hid_state_to_string(value));=0D
+}=0D
=0D
Thanks=0D
Huan=0D
=0D
=0D
