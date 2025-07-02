Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022109.outbound.protection.outlook.com [52.101.96.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DDD1B808;
	Wed,  2 Jul 2025 00:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.109
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751416217; cv=fail; b=qjaDJzDXGJv3R68lbGNOVRQfrKyT8Ot/fLI3b3CuW3zs2DyQ8cybddVYsbfvQcUtA1/oeJ/X8NnFzGQmZr+FLscPfaevvqkyLm8Xb3oxlrIb62WlLohaak1ZNv4Y/e1g+L5H11afOtbErGZ59/Ldjdq8gVed6qAQYVyuqNDud+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751416217; c=relaxed/simple;
	bh=ngetfiJvot1qPpXVafSG3oE8bpPfx3INYNO70XjZR90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Lfw2iEoUYx28p1FgG8fTy7hUaigClwjBJP1knKKVwC2oHoAYgVfqFDdCg4npSdYUO3fO4JhRaF8vaQdpB513+eut29Wb2psmU7KrlqR23YwCrlKCxCGcFPAMWOMK6XXDdSf3qcQsiYSkeW60FEHLwwqlM5LYwb/9RwuLLS+npUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OLR+qhkEM69SCt8hURJIAXA7Q+seU5UJJImQL96E9WXpUniM5yWjgz16YhrNz1idragu/E5LnA/6WOYezWFcfT2WT9zL/HUOZbmp6E93nVpb4P2TkZdqkvWbFVkbPVZxR8QAE+R/z/GP8jbJ9fuyfhiXlmIwjRhBPkJFb3GEW8I9FXItMszPCxinNzpQWTGBeJIyQldZ2Pmpts/SYMIaDD79uyyHSyq06rK9STSV6ymFlYD5Hz9c5VmvWlE8j6oJatQMVx/WWklZgbpUsdXmkAp11uLV4qCW378jubhyUVRf0hkKqUTiHOTMdzxae8TpwGZUEvCCJbVbnVBoQAGTeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nSRfK+qRaBEu8FYW0gV/NLiMUarn/Rl3QUCfXtLgryE=;
 b=R+tnwUoMelKgrpCpqBqQMNL+4Is7hl6NPNQdb0JPo032e5KrJ7ULDEt78dDNzQSa0TByHx9sJ8nG9GcJaE+HsEegxZjnzGcNOjY3LIV66ZZ+jx6fqx5r1TCYCEkclkAiFaZD+eEOVVCjrrYqp3hxdfH+XJBmR/be3kTDKvifyicm4KlBzRSZwfl8CMscoQfzhjGpCO0/uOzCmQGQAbf4Dgsasfk8zxtkKLKZ40hc9rmA5/nYKcUDP5AqW48V6ZXxLYBQsFNzDth/s8joqKasQdhFHV2vMmrI1Ah6GNTtPiCPc/LFwm6MYXYANsm+RChrs9D62jTiBt748itbF1ecIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB7363.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:225::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Wed, 2 Jul
 2025 00:30:11 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6%3]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 00:30:10 +0000
Date: Tue, 1 Jul 2025 20:30:06 -0400
From: Aaron Tomlin <atomlin@atomlin.com>
To: Daniel Wagner <dwagner@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, 
	John Garry <john.g.garry@oracle.com>, Daniel Wagner <wagi@kernel.org>, "Sean A." <sean@ashe.io>, 
	"James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, 
	"mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>, 
	"sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>
Subject: Re: [RFC PATCH v2 1/1] scsi: mpi3mr: Introduce smp_affinity_enable
 module parameter
Message-ID: <cks7tursyprqsq5dp3axagtozduzw2et2hdhbllcv6gqay2rup@f7udfe7c5fza>
References: <1xjYfSjJndOlG0Uro2jPuAmIrfqi5AVbfpFeWh7RfLfzqqH9u8ePoqgaP32ElXrGyOB47UvesV_Y2ypmM3cZtWit2EPnV3aj6i9w_DMo1eI=@ashe.io>
 <077ffc15-f949-41d4-a13b-4949990ba830@oracle.com>
 <aFjjf3qbuEOeWUjt@infradead.org>
 <0233e47b-894f-49e0-822c-bc1436352c98@flourine.local>
 <itze7fhv7yx6j4l4ammx2znkknr2v6iducahcsxdjpfbasdsz5@nz4hvmv3s234>
 <c4c82ac2-c9f9-4bef-8f6f-a6cc9a2a0545@flourine.local>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c4c82ac2-c9f9-4bef-8f6f-a6cc9a2a0545@flourine.local>
X-ClientProxiedBy: BN0PR04CA0144.namprd04.prod.outlook.com
 (2603:10b6:408:ed::29) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: 973a3530-3241-4200-9012-08ddb8ff9a2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Yk5pS1NYa2tVMkpacnVITmZDaGVXeVRiam5qNDNIbjdVUERDMHl2dGZsK1pR?=
 =?utf-8?B?RXdEMndReGtoOWlocTZlc2NxUmg5cjVKUThqaUluQ3Vkb1paNmpvTWlVcnE4?=
 =?utf-8?B?cVFGOHZDN2VXNlI4akxUYlVGaUhlN1NzTk11R1VUWUxVSld5Y3pXa3dFYWVj?=
 =?utf-8?B?bFF5Q1Rod3FUb1JDL3Jab0RpdGovaUxnUXZOUW1ER1JzM0RPN2FHMEg0TllW?=
 =?utf-8?B?QmdqZ1ROUTl0cTRsNm53dFhFOXJDU3RydUVZMXdWdklZem5KTExwUWlkYmtr?=
 =?utf-8?B?RUEyZ1l1dVc4THNRN0F1cjhYdkgzV21sVG9sOHlsTHkydzdDZUovSWFlcUpa?=
 =?utf-8?B?V2o2UnFOdmZ2Uk9ad3d5Z0sxVEFOZ3hIaHRUZ00vZGJ5S2g2ZzA0VjhBaSsx?=
 =?utf-8?B?OWVmVFhUd24zSUVPWVlYaDBQOUt1elJDaEo5OU54ZUttQ1RQVHFDWmhYRFJG?=
 =?utf-8?B?SjVxV2ViR1RZRlh2U2Q2ZWgrM0UzZW42RU9vU0FzZ2I4aFkrejhRalMwQ3lH?=
 =?utf-8?B?UVB1RFN1MEYweEs2S1ZmR3ZEbkhrYmg5Mk9uUm85VEdRRlNoNkcxQ2M2bnBL?=
 =?utf-8?B?cW1qMjJyd0ZwQWJid3NzeUxJR2dqaGNHb3VDSzM3R0Y1bXNtRHRkbEdxejcr?=
 =?utf-8?B?VUNydzR2ZklCNDNlbExHa1N5SFJNSjlwMkw1QXQ0V2dhVDBLdVZPOExVSGJm?=
 =?utf-8?B?QUpydjd1ZUFhMDI4am1jTlltK1dWMnR0cmxqcU5OTFlicm1HY1Y3ajkvditk?=
 =?utf-8?B?Q042VDF4WWErVkFlWE1aQ01rZ1F2Z3h4Mm1JejJKNzVPckNUVHRBdjdWaGFz?=
 =?utf-8?B?aHl0Q2Nrc3RneGR1RHdhNW0yVTg4RDIrTEdDRnE0dVFWamNHQ3ZQVTh3M1N4?=
 =?utf-8?B?cy8rc2g4V3lMWHlyTkp1M0cyVjlid01hbENGVFZHNnFNa2pUTm5tNGhXR3BJ?=
 =?utf-8?B?RkFqVXRHd3pvWjVqc1lvWFh5RzFHckp2MnI2RjJxVjRCNEpuamRldndqN2h2?=
 =?utf-8?B?Ymt3RHFyUzlFdzc3dGxqWkRSTDZGc3o0aXRqN09mN1dxT3lCQnZIMUhsZGJQ?=
 =?utf-8?B?dmRnSUpFb3pqZThaNmFKVGdZaXdpNUJxMkhlL1JHUTEzaVlLbEFucHNaMVB4?=
 =?utf-8?B?VzY3b2E4eUxCcTdjN0xiNzNUSnhFSmxDd1NlUm5ZbVc4UTVPTmdKdFluV3ZX?=
 =?utf-8?B?MzRUbjZsLys5QzBsMGt3MUVIeHhqa0FGM3o5cmFXYW9KTFlzZWN4eGhXMzVa?=
 =?utf-8?B?OUhZbmY3alpWTkJ5bVZYRDFmUUpZcVRXd25uejd0dExSejFCM3VDeTlONTN0?=
 =?utf-8?B?T3BCWTZwc0ZDNDA3WDVVRVZSR2xIcWhIQUMyd3liZWpYSjZLSjV1bWlPZDAr?=
 =?utf-8?B?VjlQb3ZlRXU1aDdEUjdweUk3dkZEMlBTWitKL2hreVhwZ1JiMVM2Y05hN1A4?=
 =?utf-8?B?Q2FrKzduS0hWR1A0VjlISnZvUklyeDlWeTZWMnE2N25ZMGU0T1NEMGcwajNj?=
 =?utf-8?B?d2R2OGUzN2dFWEk5a3BGakR3V25MdVhZcmlVYnZZalYzNlhzcTVFRTVsVnhH?=
 =?utf-8?B?N3RoNHZJVTFFNm1tTHdtU0hmVFpSeXhTUlhQWVRLRnVxcThwU3JsUlJJY1N6?=
 =?utf-8?B?VkVJWGpTaURYNjlwaDN3UUJTMWVxeStPUDdXWXNYYUZmM2x6TTBMOGFtTVVZ?=
 =?utf-8?B?cFpJYTdjZXZGWFBtTGhSL3duMjdCQVNHNll2TUVjb2laenhlQ1QvN1pxMkNV?=
 =?utf-8?B?Y0JkRmhCZTVQeDgvemxZbmlTVkJ4RXVYODgxeDBjZ1pybEZqSE9oMFAyQ0FD?=
 =?utf-8?B?L0ZJODA1Q3BnSy93aTM1VE5VQUxDUnBaazA4UEJYT2JuM0FQaWw1RlVubmdW?=
 =?utf-8?B?alRRamYxbGw0NCtYSWxOTmEycXE5VjJ4eWt1VnR2aEZTWjMvQ05iOTBteEdY?=
 =?utf-8?Q?9vfLv0qE2w0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUhlL2x2TU9UcmdUeWcvd1l6TzFNSkJ6SzNYZ1c4eWRvRU9NL0krZXhkdWhz?=
 =?utf-8?B?MTZMSDhwTXNDVGZBSHJEakI1d0tvOStNN0hDN25BdGI4WnpWR1BVSUFWWFF5?=
 =?utf-8?B?UkZ6a0hxYUl6dHQweWZINHdsTUpJZGV5Snd0dnUrZVJCMWFQNWVCOXMrTGFV?=
 =?utf-8?B?Y010QXNKSG1WWTkwc0xOTU1xazBLcFVIR1A0aVJxZjdmSHYwcjUxL3JDdW1Z?=
 =?utf-8?B?alNZVUNwbnJIOUx0RWlDcDl6eVJMemk2c1FySWoxOG9uVk1USFZjejJPYlRm?=
 =?utf-8?B?YlBpNnhvOTBwMGxqY1NSY1dPdXJjRHZaSWNXZEZTTEIyUjhZVDdpNEt6UXky?=
 =?utf-8?B?bHljczhZM3JxOFNacEZhd0pFUThMVCs1THJPbWVWRzRhVjI1R2VianJYL1h1?=
 =?utf-8?B?WDJlVUVIREJuVkR3OXUyaE1mVktxUkg1aHI2WFFRMnZxRTBWOWx6bVJmNWhN?=
 =?utf-8?B?S3d4Yjl5WEFxYkhuMmM5elhkY1d5cGpra2tZaU1TdkhBczZ3bU4rOXo2WG9k?=
 =?utf-8?B?VjNENUNDaGJWTkxWR0lwUWYxNkRZWHBGYkZvYk83eEphL3pibEVZK05KY3or?=
 =?utf-8?B?eUNxMzJVYVBmV0gyVjRzZVIzc3hmTzlRdU9rZVEzeUNDWGpkTTNmNldSaXlT?=
 =?utf-8?B?N1JSNDBkVk9vNGNVcE5OSG1VSWtKaFY3aFZKMEMwTmJrNFZXUXMrOStlaGw5?=
 =?utf-8?B?VTZkQ0xyTk5DR0RRcU5udklTdzk5eWhJdmxGdDF2anBaVkVsWkNOWDdraXdw?=
 =?utf-8?B?aXRhMlJrV3VOMm1jaWZKZDM2SkRDSlo3eGdrSG9weVljNURSMUE4WXJ2SCts?=
 =?utf-8?B?YVhhcWhnSXpnZWZaUXlKZ1RSUk0wenFxMFdIRUl6c1pLRjJmNi9rZDdNZGJB?=
 =?utf-8?B?N3NDbXMrN1dYZlNmUjlDSVg5YnpUSnFMNy9iL0Vxa1MzR0RxcnpqcmVqSU5O?=
 =?utf-8?B?MVFFS3BUOGdIUDlEZUUya21uMitVUldjWS9IbWF3QVJFK2VXd2UxOStzeTFQ?=
 =?utf-8?B?T3YyelJGcXU1VVAvQm0vSlh0VHZQSlR6ZGtOS25FSkkyS0IwOWh6d2pQOFp4?=
 =?utf-8?B?UUZvOU03M1FjblR4RmtpZHJ3OFZ2TmxET3J2bXhxMTNrMlZtVW9qQ21iQzVM?=
 =?utf-8?B?NjNITVE0ZEJoeFFqdythVkJpNnFUYXpJVEJQUnNyYUF2SXNFaGpMbjRTWGor?=
 =?utf-8?B?QkMwU2lvTis3aVdmK1QzbWdUMTk5cHNCVzN1cTFsbG5HVzZscXhlNllwYW5a?=
 =?utf-8?B?STN2K0NrSTBHT0tjQkhqZThiZ3hRTTBNajVySTVmYUNlZ3NPeGJrMUdmYTZZ?=
 =?utf-8?B?YWtaL0xiOUlic3FLOFlvMkwwaVZzS0NMWU4waVoxbUhZMXRKSlJUSzRQUnU1?=
 =?utf-8?B?Nkh6V29Ec1YvSHlqOHhvNFJTNEh6NmdRbEVVZW1mOW84V0s0K24xRlpKSzdo?=
 =?utf-8?B?a1d5WmFnendzbFJOczJEejd1S251OWRRV25DQm9zcnUwaUlZUkJ5RnpPZ0dN?=
 =?utf-8?B?R2xDbTdMTVR0WjdVMDJKUjlBYjRwZWZQYUx3RGQzRm9IR3p1WnpIdDBya2Vo?=
 =?utf-8?B?MW42aU1GZ0dEdDljT1liSXN3STVLcmoyanNyWk1kRWxRTVQ4WjVPUU1IRWx2?=
 =?utf-8?B?TGgxd3Q0V0s0ZVNUKy9GdUNxM09zdkxDSlJWUW9oQ01rRHdaOHhNcElzaWFy?=
 =?utf-8?B?bDhmRDQwUW1XS1RIRGlpWEJqdVkrK3FNdVBnQzd3VmVsOXpvdGgvVkZBaTF2?=
 =?utf-8?B?SHFaMmdRV2RQbUxVcTFZTVBMaHlBVzg4TUU3S2tEZUxDdzNUWWdCdTJZT00r?=
 =?utf-8?B?cmFuTGE2ZnI4d3RiUmNkM3hKQ21RT01GaGJiZGdsS0dQWmNTdVd6ZFJoTlE0?=
 =?utf-8?B?aGhtNjFGcUJxeXJLQ0VaTm5JVFdZZktpbkgzdUpXRnN3K0lyNWhWbWhhZG1x?=
 =?utf-8?B?a0VLWU9WdUVqS0xubUYzQXZWYUROOWN3ZFJyR3duTDJLVk8zOEFMbHM3cXNt?=
 =?utf-8?B?cUV3WkRQZklmKzEzVnVmZEpSWUNLWm1aSVd1Z3VVTXpqVEVnbmpVRlhRbW5H?=
 =?utf-8?B?VWpVMnRzYmc2SlZ1SmpGYjlQZDJvb1RWTTZJS3lHTjlPTGxsZVpvbC93RDBB?=
 =?utf-8?Q?VF4NnohCmlKI7coZwhytx9huI?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 973a3530-3241-4200-9012-08ddb8ff9a2f
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 00:30:10.4993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lAMXXzAEDXjgB+1Beh6qQkM0pKTrv+Nd7BuUQrP0iBNCD+BYUQhej6IrPdzXmAa+FMURO5TOfVwKy5WwWZ1aSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB7363

On Tue, Jul 01, 2025 at 03:54:43PM +0200, Daniel Wagner wrote:
> On Wed, Jun 25, 2025 at 09:03:42AM -0400, Aaron Tomlin wrote:
> > Understood. I agree, common functionality is indeed preferred.
> > Daniel, I look forward to your submission.
> 
> Sorry for the delay. I found a few bugs in the new cpu queue mapping
> code and it took a while to debug and fix them all. I should have it
> ready to post by tomorrow. Currently, my brain overheating due to summer
> :)
> 
> FWIW, the last standing issue is that the qla2xxx driver allocates
> queues for scsi and reuses a subset of these queues for nvme. So the irq
> allocating is done for the scsi queues, e.g 16 queues, but the nvme code
> limits it to 8 queues. Currently, there is a disconnect between the irq
> mapping and the cpu mapping code. The solution here is to use the
> irq_get_affinity function instead creating a new map based only on the
> housekeeping cpumask.

Hi Daniel,

No problem and thank you for the update. Excellent! Looking forward to
review.

Kind regards,
-- 
Aaron Tomlin
