Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E86B43F4B3;
	Fri,  4 Sep 2026 10:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516520; cv=fail; b=qEPUqAxcDpVHVQz8ty8c9s9iOTQs1dYx6ojI+SJyZLDd2AwSTz0hcHyVplvoI4/WK7RWB/OR1myT1fGcGrcPgHjcRCtcraECU8sq+8JncrfFDPgZObcpg+SF7WGm5pOcPGUQI0jsW8ow0+QR/s6JnECPdJu8lmnRe/qnFPWEaUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516520; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=evFA2rpFOkZZ8GZa9XgQjDjiZxr3RaNWljssmC6ugg2vP0B+yWsj45dbHMzpT9CbVKPvaXbucnyfG8PrU+dHj97BEV91bi6xG4IEQrpUYosCv2JmNMFnv2yfVJSh4gf6tZkhAcRAVd3AB3K7pKwxdzcUUuDLDuWyw+CjqAdRgjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Pg5OMUeA; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=u6ylnxKf; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Pg5OMUeA";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="u6ylnxKf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788516518; x=1820052518;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=Pg5OMUeANokjEpL2GeoLRWKJa+LhmWOxKuNN1XIAv6SezFZ85lEvPvXJ
   MPQ5M78edOCFpn77RAeOZZHIU4iiq4Pzi+2IPQ/RTL0+E1ZTectpNnrp1
   QfG/xwgwgXxa2sxzWDH5Ywweod3CodFL2DEWML5QAJzi23HyjEc2bjm9r
   QZmt3N7P1L33mbXtLfDWktzRuWfesffZyY9zGGt1W6Mto8xlmgQVOempF
   zgz3xCns03q3fm7pcYQPoNaqSbHFcEfqp5HuWvp7RU/AfRigb9WlQnIyy
   pCYYx30iV+XZjNRRcdcG0jxH65/Au4/swUdMlk7PqMi21M5X0yfwvAfhL
   A==;
X-CSE-ConnectionGUID: CqZYeMbTQ06WP0Qf+E9QZg==
X-CSE-MsgGUID: 4WPInlN+RNCCFY/Nv87Lvg==
X-IronPort-AV: E=Sophos;i="6.25,260,1779120000"; 
   d="scan'208";a="154951082"
Received: from mail-eastus2azon11011019.outbound.protection.outlook.com (HELO BN8PR05CU002.outbound.protection.outlook.com) ([52.101.57.19])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Sep 2026 18:08:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TO4Op88J9H4f51RxLTRI/VgXJAhFHeDKicMzXpyQHBxQUO0LecLOiLQ/dP98flgxd+HMH49DNAuX11pgHsz8ZiYLa6TDgXMp06RWbUn8zDUvFLsSrR/RgtlF1CU6LhQDjYDCEWT17LMKUWKuGwcWdn8wOaMCsMBFVJbox40sCqV2VbtQ1du0mbPJhsEirvOCiVDqTW+HMtTxwWtl6KzmMzMNKDJShRGXQlmD4PvH4pCbKVafdvrdzXyhuFW1diSb+edkpEGT4Fx8xARes4c4eUEqSeDFejd3T/VMZZAKm30f4rAaM1aId4MfubPKZPR07hGNqFHfRC91B16VfDQ0hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=F1B9vO1zJDkoePzTM+FRCiMqVumsra87eMIvljcwIo5H7wF5fAi8vzSKMd9trBNHDRdHd58F9vEFfKI0ttvU19UCJK9u8RJlgBNZ5DJ/A5MU0+fDjk6T8t03B9rb9M7hOS0qJnzS7baW6RJMvPBW8oVnZaYxNDnwG8WC+Ok0rI2oYTz/owUUkilJCGNBfsPF2LaNVKSom45Pqu8ylBTGM8XYe0GXzpYDZ8IFiCFXe6FzBwU9gx1wnxxzCAbJJpJgPe0iiOlOOrkkhRO67vrg/q3kPdgXTZ5bJGzayHJ5kEaQiWFLrxNq+UiN3qS3/L6H59caSkBTz0f0KLExfRKtgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=u6ylnxKfkdt8551HJd2lM2Lj8/qNOUEclAIa3tHisU3fqRiHXMbzf9OyNpdRNLdMqHXgYWEe2t0cCCAYVCEHyDNyiBxO9/+MQXzlDwFjirFOjO2SiJlSbXl4Ihce00EP1SpocfpPgH4iVS2jrkea8iyhKU6Nmt3VIVUEYNFzvY4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by CH4PR04MB9153.namprd04.prod.outlook.com (2603:10b6:610:229::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 10:08:30 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 10:08:29 +0000
Message-ID: <0cd1482e-3468-449e-b331-b63db1fbfa3c@wdc.com>
Date: Fri, 4 Sep 2026 12:08:24 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/40] scsi: rename sense field of struct scsi_failure
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-5-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260904002644.157668-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0181.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ca::7) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|CH4PR04MB9153:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dee6d8b-76b8-42f8-3e7e-08df0a6c77dd
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|19092799006|921020|10067099003|4143699003|56012099006|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	0oqE7G8aimIhJriQVJWvXiLFMKyXxzCTxCxEzFcp++5yxXmSIhfMBw6nKJg4UNQbHkcj4v5CXGICyZERrqoJMxA0SZDydZEx7BXYhEy7O6xm1eP1wqhl1W6KNgB/IzU7lzjzfTEey5oE8356LJbXBKiZFXAvzG5Z2khH0gvxCBcI4vrdXGjO36w6QV5AHgplO2TEPEwOZrT/VT/EPr8nhFe0sWcHseVF4pLYIU55PTHtbATOD1DpIH3Zf1GB5kO4XRbdtwCgdbI9kn6C2zpbklc0UPJumolMvPLELfqQWIHuaxhl9QffrzIzkBPLMwOId/3JR2PP3sf6nLV4EXWh4G/ULmju6QDRig7oQwi9H8Tba5il1Lmm7YVz03ivVJDLnFCLKfNLAzpodBxiRCnPma++4RIIBsXL/qRcwtftaU0JD/NxF7CfZbrKPGB/apcS0rTd/KW2UxvbqceL+ZzKtWwbnFtoeAYn0SNf0mwwyJji6T8NLRbEH3kfNQNpYNDlI/2uByj9AE6fpZeYqlVkciqhPObe6ZQ4JLWs5xfbUd0OKyjcOTuXkvVb+tZA7h6KpYaSzPVZs9hPPXHWdwHhKFAeabRvfGgTJVchM2G/oQzDcbo0B1hHpeVpWohjYBnQFYqURlkxs8Dcvl9fU6D52vCz8pDeujdrt3u3SeQjEeFSpUpJr2LN5KtyU7vnFCs6lfb4WMylGVDpPLvUAJVn7w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(19092799006)(921020)(10067099003)(4143699003)(56012099006)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a08yUEhVMEh2RkVnWVlDQnpZTTBjaFh3cUNOTVVSeTZqdEM2TnF2R2JSQlVq?=
 =?utf-8?B?dWVkSEEybU9rTzd4enZjYUE1UHpXTVFXU1NVKzlObWVIQ2o3SnU3bmRlTUZs?=
 =?utf-8?B?UUhpQnlsV1BmbGJScEF0eHJ6MHJvSmFHZGtIOUtWVVJmQXhXWE1rSlFLMTRK?=
 =?utf-8?B?U1BpYXNLblRlSXd4RkVUSW1NcGlMbmdaekZUVW11YmhscGtUay9Jbk5McGZa?=
 =?utf-8?B?cEQ5ZDJxRklkNFJtVG9LQXRONVk5dmVnQzZrMkdldWdGQkl2NkgvU284WDVz?=
 =?utf-8?B?dnhLR0RzdjFicFR3ODN3NHVBRmZjQXZ0bzBUQjVpc2lXM2czSk1yN2xpNi9U?=
 =?utf-8?B?WGZTdG9BbkpwREl2LysrRmlVd1grMTlkQUFndFI1VGw3SUdpQXMycmJPNlZx?=
 =?utf-8?B?VVBscC94aHFXSEk1TUNCbmh5cjRtdm8vS1Awb1JwdURrZ1pUQm44RFd6TThq?=
 =?utf-8?B?b0crbE9XN2wxMVpmeU56MGVTUHc4MlNIUVhFWmtpc2xWejlUNzE1ZnVreUkr?=
 =?utf-8?B?SGhMSGZEc1RrYThjditKWHA2VDJTcUVtV2FneE5nNVV4UTU4MWdLcnI4M2tI?=
 =?utf-8?B?VXhDWTBkV0MycGpibkJWbUlGZlF5RndVQmpady8rRnVsS2xQV2NlQmNLNmxS?=
 =?utf-8?B?VS9FTUkyTE82SDZQaDJteEdCSnFqREJHM0tIVTM4ekxxd2s2WnFoYzhRRW9G?=
 =?utf-8?B?YTRGK0o5K21jS1FPRkp0WGhyNzEvK0JEKzk5dEhsOHZmOTNPTjVwMCtXdzVi?=
 =?utf-8?B?bDl1aHdON3p2a1h1QzlITitvZHpJT29FU29TVFRyQ042bGQxQ2tQMXVvUTRL?=
 =?utf-8?B?MGduaUNjYmx5SlRmL3QxQ1NvRERYYjh3QUJIWGRBNGVmSVFDa0JVSk5DaUpy?=
 =?utf-8?B?QjE5blMzbkNBK1l4MjBwaXc2a1BpcDhkNTRWZyszZitCbDU1MXZBSTBnYkZm?=
 =?utf-8?B?QlQ4VHRnVFlmcTcwY1NhUTFTVHVhM0VaY0JVRENIeXR0d2xkWnpmMGIySnBw?=
 =?utf-8?B?U3FsZUZlYXZWQWdWSmZFYlJ1cHd1Wkw5WXpLcGpVenF2WWZVajRIQ0dobERE?=
 =?utf-8?B?OHBPaVl3djB0STZ2cVl2Z1lIV3RLclhRb2ZYSVhwNlBRVVUxYk44VTNaamVx?=
 =?utf-8?B?T3lqdThMQlJrQWJxanBxK05XVEV2OVE1REJVTUFvQ0E4NUJEYW1mNGkwcS9X?=
 =?utf-8?B?ajVsc0pxVk9pTTB0REE1K1RrRkJINURFc3NVa0xEa2oyT0t2Q1J6YjZvSU5Z?=
 =?utf-8?B?R1VOcWlkczIzejEvTHk4ZzhtS2JkMWlTdHA0czNCdzR1WWxJQjhrWjZwbExB?=
 =?utf-8?B?ZlFwZmlFZ0VDWFg4dFl5ZFZLM1JtRVczdzVDMDdHVUZxQ0dJbjMzeHVPNWdE?=
 =?utf-8?B?c1UvSHV5UVdOOG4rckx4eWR5bUtxWXF0TEFNRUhuL1VEcGdiS09BVjNGVU9y?=
 =?utf-8?B?RVlxdlEySzBHMnE5NkM0K3Q5L3cvVEJQcDRYaklaNEdvTTNCSlZZYktxZVNU?=
 =?utf-8?B?Y2RrWUxJQVQxaTNubCttblhmNTN2L3hCN2I0c2U5SXNieW5Wd21kUVJIVTBm?=
 =?utf-8?B?STloYjBwcmgrN0Y2MWFtejQ0a05kYjlTSC9nejhaRzNNMG1JL09yUXBIdGtZ?=
 =?utf-8?B?eUttb1U0NWpKZTcwVG1sTHBtWi94dzZhMithMy84QmkyRFJIRUtEWGJFZllZ?=
 =?utf-8?B?QU8rMUdRZG5BWGJrSlRFTzQ4Zi93Mml3RFlIeVpMYStZcXh1emQwNWRJdlN3?=
 =?utf-8?B?Mk5IU3YzK29SMFJLVGlJem1jNkxoYU9LTFE2dEN6MnhQQUlvcVZYV0RMUnF1?=
 =?utf-8?B?ZktDcnN2TGFOZ0lXQVBuV0E4bm5ubHg1TXlOSmlzRXp3T2lWdUljNG5LUStS?=
 =?utf-8?B?dENaTjZIUGdqR1QxbGxLUEF6czlFQ2NWWGdMTXdiM1NJRFpoU05nM2szOG93?=
 =?utf-8?B?R3R5aU4wenFST2xyamRCdHg4Z2ZiVHFaNWU4SU90RVQ3cG1rN3pEK0JBdmhV?=
 =?utf-8?B?bUVMYk1YT2pHUHMzajA5a0RsUEFIeWs3Ukd4K3JmaG9Qd3ZUNVFLQ3lhZnJP?=
 =?utf-8?B?WVU0OWJxbDJQNllwT2tsc0o1UFpvMktCMEJoMnJtZjl2cXZPUUMwUEVQYlBa?=
 =?utf-8?B?QWtReTV4Qno4b05mZklEdk11QXNpOVhPUnVHZERmUUJjQUR4VE9TaFo1NEsv?=
 =?utf-8?B?UEZmc1pGQ0RnTDhTZVlJbWIybWxpSU4zVkN0UDN5dTVtWWUyYUpjSnYzS1k3?=
 =?utf-8?B?OXhMWng1S3BRK3hyT2lNcjJXZFMwVzdpQ3Z6eHFHVUpsTHEzWU1JTXJHWUJl?=
 =?utf-8?B?ZnlmbW1BeWFZdjFpMzRWK29JYzUweDBUZFZNQ1kwZm0xd285bWNFUFlZeUVE?=
 =?utf-8?Q?+6+bopI33zMONqSM=3D?=
X-Exchange-RoutingPolicyChecked:
	VfD3zOD3iYtRsvQOX+jM1MF3LGzBwrRY7lHFVmeMvx1IicZEpWsGjQNF6g5pLsZ0dveOG+m4lpxphS9pfHDE0Iq92ZoaJ82pPrFGNDACD+WxojRYvx6c487RqOOJk4VsRftVREbgkDo7j3fObNref8V2I0H3CgGnOGuAXK5o8f+FsmXXbp2ML5r36wOBfm2GTFz2VAcLp4d0pQFJm3M5L4jVfoRsjhEq1ljK6N+pertVJXjg0UyBpcfiHaHXZ83DN2YMB5f92sc60hnNWT0e0Gw578mmVVH5rsDk3Gy0Xr76lRy7ac24q7ZMYmT83T8vcefInU4jpRNedaXZqpoi2A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	m9dd+OysERPwjI4O/y7XtVv6hOmXngfAY5vKWq3BSvT5GbAwV/I2Dt/w0SlPderhZgGEJtC92zW0sBa/4KvEh0F6JLfonfURTclHYAus0GliGKNESoXsxX/FuGYSX0vAu+Ov3u0PAIaUZ7UK/O+ll6XoRuNVRBjVFL69Z3eqK6uFfEJFlbGbHI7oAuQ/QPq03FPqpH6cqs3kc0Md2tROW1HcSkyjEH7Mm0k9DUQ6xi98fXQzyCPKmpfDRmbYwT7hL8EHMzDCL3uszoPs5MbpzGWj5NlagFMFjgcsEMFqLMuVzThBpT9BCYzABVEhYYuGLBU7HXCKIriVa5YIK1+4WB5GTF8UB7lrMdpztvJw4WjQIylYggbk33geU4iBI2DTqh8Tu9iC9qF4WWrxO40FQTfEHPQuRA7Dxn+rOL0jCmwow1i9l7bHNo4Ltfv9Zg+ggDInPUjJ7gks4s3PReVS5P0QnsRZ8l9hds1C1ggWKZsJNY4DUUTMzQ9am6ihBA5x7uCpWrPXQYsJ58JOG51XB5FbcvetVYGV+lCOd3HignCkdWMteZIlzMZYWNy640OlS8L6iqutx9kPqWfd5RDdWfUxfPEtSNGO4h0Zrt0xiTrE9mnlcNiGReBYMcp/B8m0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dee6d8b-76b8-42f8-3e7e-08df0a6c77dd
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 10:08:29.5936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eN3hYzOn96xud/sxzhuvklH5W1vERpI2AiVYnTmKKpJVHbJo4RU+chuAxVY4tLkMW6DVlQAPOt4obfWzm6ZCLlrcmSo/b1lc/3V6GJhmBrA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR04MB9153

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

