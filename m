Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022088.outbound.protection.outlook.com [52.101.96.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23692620CF;
	Wed, 25 Jun 2025 13:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.96.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750856635; cv=fail; b=Z23jtARLYd1NNyezUgyo4O9GWPWZeSkP3TMmhyz/xB76eXNXaTwL2hJtjlV7BmaVUXe06hbmciYuqTCLEY1ov6xQiLtnXyR06PARS4cLCmkG4rqCI3djH815fbdGrcSwCGb1MNu5c1gicy3u2kBnOJsOKk1KlIFq2nmqnfDEuJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750856635; c=relaxed/simple;
	bh=dUIZOC/wJKJRuKFU2VOlwS+CjTKMAAXHBypRi+QETJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dZ1kxa6l/u2cw9O1Na4WEMU6oiGTGDRALEwjzYoj4dCY3oH7k0+EdjuXgp2qxCgLNzbPTCW5TGpZ0wcVl+8/DswRUPYrq/aEumJzK4KkS52mTrIaY3QzucVVqtcaDgEf8YhF+Dk3AxLHnx3dZcqQV+9tHwvl6uMXQW5U52bBG+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.96.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J75R0CfW/EG5CrTEvnb9O4t3ArzuFK2CWBCUVI48mJ5hO6Paij5j/bxradrhDZ81pCqIYIwIhTAU9ZqpFPPfd0ffsFCaCHzJxwo3KEKGnfXlCPaTK5kK1ih4mwT33V4K1VP1Iq+HF+ih4gIljeJTZ+gM/dW041hMUXi85t/Rc2RRebDx57H/UsqaPVe7AJ0z7fJqVrdA1EJAqLsrKXPkJX61K5pZiw5o/3PgvEEaRLxTL45CV4fhSTeORUunIQlnu3TaH1epH/x4ezHWEOOqe2OlOWA+powRdbmcQwWB9fGtBHV6dOnTVdXAwbYGNpfjpx+gWceEJ/WqZtpth7WJog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWH//OGUsS2lxWOrviWeBD4me+vj+MA/jvU7U4F0CL8=;
 b=zQRVX8WCXd5H4ZdmT1/dt0OvVGvohLoqTqLCdJlpesZeMy+d1VZGsIiFEQRadVOHcMohEf94VkBSMPxsQgZukAiIOgW9N9edDVUHFEgtey3AoidcM6kRKmPjgpMTM3EPPx7p9Fbk3XDyC2XDvMxdXP2gVMfWEeJc8nRwjQQ0v6wFhb8jVv2BvMNOH6LYsemrxV2l7neLCK5y9mvDM3Oj9Y03e8ETiVjiX6MMTN+78myT5d/yKny8Ox3I+rWoERn0v7ppxkZVpO7nH+RbASIUxiWOE7d1pNbZqG6ZkTD4xalAxwe3rWFjOLwcaKBll/7Nuv8cUCNiXZv3USla7JRjjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWLP123MB3875.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:a9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Wed, 25 Jun
 2025 13:03:46 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::5352:7866:8b0f:21f6%6]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 13:03:46 +0000
Date: Wed, 25 Jun 2025 09:03:42 -0400
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
Message-ID: <itze7fhv7yx6j4l4ammx2znkknr2v6iducahcsxdjpfbasdsz5@nz4hvmv3s234>
References: <1xjYfSjJndOlG0Uro2jPuAmIrfqi5AVbfpFeWh7RfLfzqqH9u8ePoqgaP32ElXrGyOB47UvesV_Y2ypmM3cZtWit2EPnV3aj6i9w_DMo1eI=@ashe.io>
 <077ffc15-f949-41d4-a13b-4949990ba830@oracle.com>
 <aFjjf3qbuEOeWUjt@infradead.org>
 <0233e47b-894f-49e0-822c-bc1436352c98@flourine.local>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0233e47b-894f-49e0-822c-bc1436352c98@flourine.local>
X-ClientProxiedBy: MN2PR19CA0047.namprd19.prod.outlook.com
 (2603:10b6:208:19b::24) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWLP123MB3875:EE_
X-MS-Office365-Filtering-Correlation-Id: 7046f40a-d7b0-4671-4517-08ddb3e8b7fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VW9aYXpHNnRUeWVCb3ZEQ3ZCcjZxZWRRMW9CdFBXKzluQlFNS0Y5NjNnZXN3?=
 =?utf-8?B?cGllY1FOQ3ZZVUcwdlFuTk9NemJNWml0Y1VkZ05TZzVsd25kSHUzY1hrRExV?=
 =?utf-8?B?SWJvS09QSkZ2Si92L3A1VWFOQkhqUm1MQ0lraXVVZHltaHRTTVBCWWh4djNr?=
 =?utf-8?B?YXZ0anlqQUg3anp5MEdQRTQ3NkFGY2p4eWR1ZUdqZjFlRVNGWTg3ZTdUTXNQ?=
 =?utf-8?B?aEJnNlRncjJDY1JEQW45KzVYWnpSTWxSOThKRFNVOUZ0aHJ5NTdBKzhaQ29v?=
 =?utf-8?B?VlVIUUZJN3JvQktCdjlDL3VwZjZuTTQzbVlNQlFob1krRzBLa1ZobTlGTzhq?=
 =?utf-8?B?dG1nWFRhbzB5T2l0WE9jL21ZNDJON0pJeFZzZXVPNkxXallPbk5sY0ZRNHRl?=
 =?utf-8?B?c1lMU0dMMUtwQlZKbGs4bjFPek5kam1YaXJVN1d3b1ZCVjRQby9ENWowNHFP?=
 =?utf-8?B?WVJTTVVVc0J2RHpIL2FuT2hlbWF3cmxFMDZUU09FWDJEdm1KU1o1RXk4QVdT?=
 =?utf-8?B?TkJwa2dORTllaExZVVZGRGJIOHB2WGw5d2x2MWhuQVdZUHMvVWtSV0V3ckU5?=
 =?utf-8?B?ZkVVMXdveHJmM2Y3MkNqNEZmSVAzTDlqOUxKdVV5WlhVZGx3RjZ1RWJpMTBp?=
 =?utf-8?B?THhBOWhlT290WE04RGxSM0hGS21jVjh6cDJRSTlHcmdtbmEzdFJsK1VwdFBH?=
 =?utf-8?B?TUJSSWtOY3FvM1hESmg3MU9ZZythMlBzNHVBbXlvNXZnaTMxSFlZZFRyMFNG?=
 =?utf-8?B?WW5rTlZXUDZEQ0pTRWRyaXdqSTZQR3lDUGdsdDdTSU5zNFM2NkdYSUNyRTBq?=
 =?utf-8?B?anlmZDZrZmtnQUF6NkR6eUdYVWpnQ1JiZ2FqMnZmOTZCMnNQbXlVeGk1N2NF?=
 =?utf-8?B?S01rZ0lrbmtlQXFpWnNUTFRGZzBhS0QrNnpxQnFpMWlPZVg5MUpvN3VEdmlP?=
 =?utf-8?B?V0d0akdveHN4dE02YjdDZlowMG9QV3dPcHEyaFJ2bW92elhSckJPYVNGaU1x?=
 =?utf-8?B?Q2pUVnpLcWc5M2o3dmE3aGVYanhYV3B2VU5zUzFhNGFSdHhxVEpKTTV5UWdS?=
 =?utf-8?B?QzIxdG1lMEY1blQzM1hMb0VEYWV6VHliZUJqQkFEV21JYXExeElSZk1pUjgz?=
 =?utf-8?B?NWRLVi9udFZZZFNlWWVRQXRiVHlmOVVFbnNFMmh1Z0tpSjF5UmVSQVVlNlQ3?=
 =?utf-8?B?cWNHTjJZT2U2ZjQxeW1xMTRDZHcrZWRrZHFLSVpYc1B6S1BrcmU5TG4vdGhs?=
 =?utf-8?B?UFBzQVNkdUkremtYYTRUdktNTmViY1JHQnJYODM4Ym5EaTRJU0NZWTZveElq?=
 =?utf-8?B?VjZPSWRldWxzZDRIMUh5dW05anY5ZVBsWER3WHEvVy8rcVpSaDdCRmxZeTk2?=
 =?utf-8?B?RzRveGUrYjJldUluL2JMVG9CSHZvd3hHMURoYk9sOWRTLzhIQXZGbjZTZ3hv?=
 =?utf-8?B?L1ZvM0R6ZkJvaTBTTW9Id3NGVFBZd2xlMytzNHJBWDNEY2ZhcWUvT2NUMFRK?=
 =?utf-8?B?UkEybkRPYW9xbWM3WnIzMnF4NHV4ZzB6VHNOdXlNakxoVjB4RTBWZThUNC9Q?=
 =?utf-8?B?Rmw0aXl5OWZicmt4SUFCYXVOR2ZmVWFFb1FkdGNnWmYvQUl4NmkyY2xiNXd2?=
 =?utf-8?B?VXdIa1B5Q3h3TVBQNlcwRmxkYkFwdHllY3dOOGNRR3NMeFJpNUFmcENDVFFM?=
 =?utf-8?B?TlRZaC9KVVRhSW1zZzcwMnNEZEJCdVl3bzlOV0pxZ2h1cUdiTlVPbUMrcU14?=
 =?utf-8?B?UEJIV0R0eEhBVFkrTzgrOTE5Vm9iWERaVksvNlIzS1Q5VVNPT1JsTEdjZnRq?=
 =?utf-8?B?KytKVFpMTmFPZ002cEc3UE9QRU5qQWtpSytVNjRxQzhUWHZ2bU1VRGxRUG5L?=
 =?utf-8?B?MXRtQkxZZUw3NHJpTHpaREozbThqNGIzTy9KbWxiREVGdkpMZzZ3SnRQalEv?=
 =?utf-8?Q?bJm6QVFJLxg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NUtNZWtTUjk1Uk83QjRQTlBkalh2d0M0Wm1ralZNY1djSkg4V1JGREZNbjB5?=
 =?utf-8?B?R3BrSE9lMGN2SUtnQzBuSnRiZkh0d1J6SC9Bd0ZhQitNNFVzQ3ZwZGJkWmk3?=
 =?utf-8?B?TFRtS1U2ZHh6SkZHNCtndGlHbkVZWFJiZGVmckhXSDVNdXZ0aDN5a0Y1OHI2?=
 =?utf-8?B?MzFHRlVtVXl5d1lsOFcwaFg0dzROUzdvN0ZYeHkzb0ZuaGVtOU02WnhJUENM?=
 =?utf-8?B?NzQ4QVo2cW53VHBDRUlONmhzUjNwT0x0U25GRmRJZkpYS01vTk9kK3ROOWZn?=
 =?utf-8?B?NG55dWdZZ1ZTZE5jMFpuTy9qRU1IUm1jUWFRemh4b2pzZ2t3YWZNOFRxRTNK?=
 =?utf-8?B?Q1pQYUFnOXR2NFJRSHpwNUxqcTd3bVJFdmpjc0M0ckl1dWd3N2VPdWttRzd3?=
 =?utf-8?B?eTZ2WCtDVm5hRGxYWEFVMTJ5RUJnSEVPcG16SncyOHZjaGZ6cUUweENGaTVI?=
 =?utf-8?B?dzU3OExQcklLbjFNamZZczN3TUl3eXg4VTRWSFNMeTFaSE1FdC9XanZPd0Yw?=
 =?utf-8?B?bVM3bDRVaUtnM1VlOWlwSzM0WnV6NmZJWFFoTGpVZWh2YW9IUnJmL2JxamVO?=
 =?utf-8?B?RFE2bFQyNmROQzducDBvY25vWExmeEZrQ2ZpRkpVa0hjMlBUUmhwVDQvVWZ1?=
 =?utf-8?B?MkdDRmdMK3pCRnp3MmNCNXYvVTJNRG9rY0l2cVZpNUY2YlRPUnQvWmxuTGxn?=
 =?utf-8?B?RXNWd2VTOHlDSE14ZW5GbFF1RHI1VGZ1VlhCUkR2cVo2MTVBWkY3dHJXTGNl?=
 =?utf-8?B?UDdzVDZieXIxWStuYXF1Ti9pZ1NtN0VHSS9EWUdKaS9MY25QVno1bmRuNzQ5?=
 =?utf-8?B?Y1dOajJ2MG95SkpmU2FGSk5FeHRaMUJjeGxTbDJ1VzFXWWdNcUJ5bld2K3Br?=
 =?utf-8?B?RDFNeEFHSDlDb2pMdlBTSmNBazJFYTB0UU5qWXc5YnVIZEh1bnNPU25jR3Iw?=
 =?utf-8?B?TmhoRzRFTGZFWVdjZUFkWlZGVU1wb1FheGVTZzRuK3FmUW1QMzdpUTdvcHo2?=
 =?utf-8?B?KytOeTBOQUNNc2dBQW85bkFiaHkyNWxoOXY0K2hhRWhzRGtybm85L09PVlli?=
 =?utf-8?B?elk0V0JZeEVPMUs2YlVMQjFMS1UzVWFYS1ZJQ3dGNFV2WDRjUlhWNER2eElt?=
 =?utf-8?B?QkJDYmZmaHhJRjZYODA3UDAraFhOYnl3NVFjSENNWlZ4N1JmWnZWbGhUZlNP?=
 =?utf-8?B?WUxwdktUckFHR0o1NlpNUHdnQkxaa1EwcHdyZFZpNG53dU1abHZ2UFM4eWQr?=
 =?utf-8?B?Z1N1dEZRTGtEbG85aUV5cUNzeXpxbHpZOVRUcENBZTRKQ2p4SWthaEc2dHlN?=
 =?utf-8?B?V3d5eDFxMG1RWHQySVdCT1dWcnhHcU5yb0pQRHduTUFzQkhVZ3hTZms5RDZm?=
 =?utf-8?B?TUFkMDJPaDJ3V2k0cEJET0dSanhweUw5TjB5T0RYUk5GY0xCSHdtbjJnelBn?=
 =?utf-8?B?Z3VsVzNpNnBTVVpZdVhHbnJRd2QvWVVXODNyb3ZrRXJCeTMvUG9ocENPRk1J?=
 =?utf-8?B?MG5BZDF0bzNzRFNoNHphaWpJQUlnOEdKbkVYSjZlbk5BZUxZQUNFV3ZLcVBm?=
 =?utf-8?B?ZWEzM25EY1FvN2MybVRGRENyMkQ5Wnl3eEpQVS9FSDB1a3Y1dnBSeHpnQzc3?=
 =?utf-8?B?OEdWYm1GLzdUK1dFQUNHWHhZT1FYWlBhK1I2REVaQURHMGlYMTJCczlLMkxJ?=
 =?utf-8?B?eHIxa0tEbFdLYXlFVWhMRlZGSHVjRmFCK2g3MlNiZVBLTGc1OVVKa2xCckFh?=
 =?utf-8?B?UlJJaEtsc2RQTEpzVjNCQjEzaG10OGxuQzVDWE8zQkdVV0NnSU11ZmtjNGpH?=
 =?utf-8?B?U2E5T21ZeFVmR1BoYlBWSUt1K0lMQnozU1JXOS81Zi82NlZiNnFZeXVjOXNz?=
 =?utf-8?B?T2dNWXBwaFNDR2NxaVBjY1h6Q0F0Qk90bFVVQ0xZUUM3SU1qc2dDcUxJVlNJ?=
 =?utf-8?B?N3E2QlcvbHVMd21NVFlSZTIzektSajhXeFlUUnVaaUord1BhYy91c2tnQ1gr?=
 =?utf-8?B?TVo1L3dpSlJTWmc5ZFNjdmhYeTZLNEM4QWg5RFNRNm5FZUlQbmdDLzJsVWNr?=
 =?utf-8?B?Ujl4Mnl1a0lXclJmSTMrNDEvQUxvUStxVE0zSU1jQ2ZwODJrM25GSm1pc3BH?=
 =?utf-8?Q?zxztdJEiZUHGcaDG52KZUEuVE?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7046f40a-d7b0-4671-4517-08ddb3e8b7fc
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 13:03:46.2164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CPkUZU/DsEvYMUyXAxRwtuY4kQyU42s6kznwqiF51R/QoWRwMFsVK9eGIy/Vbli11CDGQKm0IL3jjo8lp6tQqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP123MB3875

On Tue, Jun 24, 2025 at 04:29:58PM +0200, Daniel Wagner wrote:
> On Sun, Jun 22, 2025 at 10:17:51PM -0700, Christoph Hellwig wrote:
> > On Wed, Jun 18, 2025 at 07:49:16AM +0100, John Garry wrote:
> > > BTW, if you use taskset to set the affinity of a process and ensure that
> > > /sys/block/xxx/queue/rq_affinity is set so that we complete on same CPU as
> > > submitted, then I thought that this would ensure that interrupts are not
> > > bothering other CPUs.
> > 
> > The RT folks want to not even have interrupts on the application CPUs.
> > That's perfectly reasonable and a common request.  Why doing driver
> > hacks as in this patch and many others is so completely insane.  Instead
> > we need common functionality for that.  The core irq layer has added
> > them for managed interrupts, and Daniel has been working on the blk-mq side
> > for a while.
> 
> Indeed, I am in the process to finish the work on my next version for
> the isolcpus support in the block layer. I hope to send it out the next
> version this week.

Hi Christoph, Daniel,

Understood. I agree, common functionality is indeed preferred.
Daniel, I look forward to your submission.

Kind regards,

-- 
Aaron Tomlin
