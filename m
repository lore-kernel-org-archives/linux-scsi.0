Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1631C51A753;
	Mon,  7 Sep 2026 16:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788798104; cv=fail; b=q8UPhQVATCVhdOjkwQ2yy9r2iVCeygBLM8LemELhCbFGLn7Rhp4b8POV4s6sn+Qvwz0e7wbh1sOjp2tKGfTJBlnDF1nEcWJg93xejeXlWfGyx7xIelRAeEGr5TzxMrvK8K/F27q63yztmsw0RS4UDwea/URYg+5G7MFNS/QFVUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788798104; c=relaxed/simple;
	bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dD6ROZ9vPXwNyNt4E03uXRgvkrb6js4vB0OrZ/b1pN4WmRUNrswSqmeROxRO5B9Q9Q3Vw3NZQJAvS6gpwmzQryvSnFWRKqxx0g/t5CRVZgIcbXoQOcAEa8vkBimO9Oe9AXkotaYNskS6GJnVYO63m5I6Z0n6sIzRQ+nc1L/xTRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=liUN1VOk; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=M8mnKGre; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="liUN1VOk";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="M8mnKGre"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1788798097; x=1820334097;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
  b=liUN1VOkxn1TykMACdb9ZJSaovMY2F2oao2X/fYyQasbdOnURrff9DLi
   TU96FzzBFDo2MPbTGvBzAMksOTSHdmOaTg+B6S/BFTrNHmhePpndeZoR3
   CZs5V3iWFSuXRzsvQDimIGjaWHUdxlxiuvyBG2w4DjXATWby6peWpr4ev
   uG69Qbu5lkAeVLFU3nPAGtpPMuTFxV3H+sn1Lt7YUoWjD49EMrq80g7K4
   nB4JoZQEOTojGR/DbfHDaChppDcgntkmsrreKcqUp/jc6csd5bN/SPffw
   X3lTbhxnOs+FgS1M6Ek5moKziJYwKIe3+FXUke0+nlGZGrK+QH9a2auW8
   Q==;
X-CSE-ConnectionGUID: +dK7reQVT/2hW2I3jx58lg==
X-CSE-MsgGUID: GRjP5AC6Qb+KRuVvZSvOjA==
X-IronPort-AV: E=Sophos;i="6.25,267,1779120000"; 
   d="scan'208";a="154930045"
Received: from mail-centralusazon11010053.outbound.protection.outlook.com (HELO DM1PR04CU001.outbound.protection.outlook.com) ([52.101.61.53])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Sep 2026 00:21:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wfui2imuPPNPhl5oB9NLV683Z2/A9uPD4oiecDmqRT1jKbt1DHmy/FQBJuyzc0O5epXiZL1O4TWion3VqvNEZXZ7CBghbowAVCO+ORBP9C775UV9p3uTi7O1oESyxwh+Gmjs9wsLm2togadPqjriWgoTdUI7sALVaNT83vLw+EcDgF6fW0x3oqClJwAHKQD9Oy8eIwzjAAAdrF/O/vFzAnjAgPo3fPnP3R84RO6yJSQeMHL3Jism1wFfcKIk9zoJtCwVr4HftxY6Fan4Tyiri3soFoU4xGHPrhy5Pbz/4AGffdL8oVE7u1Xnq4tpZAsbK8GsxOv4M+6auviIxTGR0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=orFknrVMAYbuDCSHoZehyTkMsXGPD7GeP2tw4GFam7r/nrMjvpyjlToPpk40ePlBBjQMLL1J/dMhxUsBfJP60ZIYverS5Cwc5iNxocrsrlY//8avAxdQ2do5JLTQKKMSoYiVJUbxNp0mgqkbcw5NV2ZT2xspOLyJnmM6hIx9VhEfRpqjlShCBNI1ILdOUaGiIyBkqOWW6p2GFP2VRoyMrJDtY2HV+8p1EXHr8pnWYZLpIlgpTg091xzjD8/U1rqo6GBEZbT5OwwEaQHpAxmTDNDmE11NSEfSLzyRDc/FmIi6R/YtlRMCAjd5XOa5+AiHXyUvO0z/2kyXiaAad0VvQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hFm4yO+V2KgeQG0ik8lLOHczCQdLX2syeEcd394fgI=;
 b=M8mnKGreSWNHCGG+zc3BhBAxolz59Mqjli8tq6qGjYIpTSwbK5riKCI5jkoPZvPcufunjpTur+aFafGIcNvRXK+XJzme4ZQgNW0JDnsTQjSzJ0/bNUTEy94ngwZjwrB+88u1Qy3047JYoh5jsB0bXgyJ7WQQwzQ1tELBr8NmjbE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by BL3PR04MB8154.namprd04.prod.outlook.com (2603:10b6:208:349::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 16:21:26 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 16:21:25 +0000
Message-ID: <3478d307-047e-4265-9737-57646fb8568a@wdc.com>
Date: Mon, 7 Sep 2026 18:21:21 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 36/40] cdrom: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-37-dlemoal@kernel.org>
Content-Language: en-US
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <20260907024343.1046387-37-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0025.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c9::20) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|BL3PR04MB8154:EE_
X-MS-Office365-Filtering-Correlation-Id: e49b32c8-38ab-4d61-a99a-08df0cfc105f
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|7416014|376014|23010399003|1800799024|366016|921020|4143699003|11063799006|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	RNnraINSd5p+YBtb6C2Vl3BPnUh8K+dEwzrrQUnwLHOs8zRVF1nH6d3cz+uhb8BsfHVHWD/x2ydB+ce9A6dEk70Wy1mGHb43+kP/Sp3PLbqUWEt2goCHsaUT3hHhbKaN+PD+TIVjyJYMckT5MjvKb/tPM/nyvIdTuw6s1R5agNOcBOjv4aurYMgV7VVu1xWfobPIDem9lH3RnVtXyJLX5ikBjXB9B+INaHVCGXZz2HAcme/kWuC8tG7KUKcZMr+ePakzM7fmgVhyFD8JlOiaDYRFkz1rifaHe/jT+BdWbM4UxWTcGMTj6fBC4JSDW2llP6/22Cmds9LxOHAKehOP/nbLFu8jeiLHvhJUdthjNEfdVEnJ49UVBPWMCJv2Pq3Xre8SjN/FGBb0fDu5PFZIyjuRrS2wVkSB83r8mGzMSIq7QT3iyrOKZVgI/1Jp3xL1vtqfmwNBDhR3hV2eWPE+mg/7D6+MjaoUnmH/UD8WF6/Kv91yt57RRpCwMicYbCYihk97vQOns8QzTKfHcqVVu3s7lxSE9xKxpKwOr9hygyCiv2F3/PME5CaPhphGAVFJ7XcUQT7rSznbmLy1elOw7R2JtGkcWb0nl7vzPJqxs5bIsDQKqcYkQM75mkluFR8GbsLsAxVwy6ZcR8PrL6cqEkq96tDKyIb3V/e85T8Dp3cS+8e/4YP8w9vd6/4oG6LAp8YR6FWg32FWNPXtc10Omw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTRBTDdZRlVWUnlHNmFtR1RvMlZOSURNV1BBUGcvcCtYYmlFVG1QMGtBYlkw?=
 =?utf-8?B?bzN0bWlLQytrK3g3VFZML1RsckV2VkZmZi9EcTdMVHIwZnV5UVVNRkVteXk2?=
 =?utf-8?B?b29uaDU0QmY5OHVnRDg3SXM4Mnd3Mi9iZTZKMDdGOXZ4TzdlOVpGN0lEOXFW?=
 =?utf-8?B?eFlHR1gzSC9INDQrMXUxTSt4cDhnRWNVeE9wM3c1c0RXQzlaOFRtTjdnRTlB?=
 =?utf-8?B?eWlUMElsaVdBaktCaUhKK1NSd2hSSkFXMDFSMjVyd0s5dmRIVDlZTDd6Q056?=
 =?utf-8?B?QzFodmJkQ2F5VEhoZGxXcTZkUTlCcVRGNEhIbWpBOUd4TGRWYkhFTHdVVVk5?=
 =?utf-8?B?WGU1dnpvRjltWG9GUzhUOVg4QnBMY2g0Zmp3NjRiMlQ0djFkZzJ3MmVYOE9o?=
 =?utf-8?B?eWFMYWExamlHZXBrdlBmTGpIRVRZaGZOcE5nQ1piM3hxWEZhMDdmNGVKZGZu?=
 =?utf-8?B?V045d29oYVJTOUJFZW5uVzlBRDVBVzlhaSs1SGc3cVlITnpKYkZEMkdyYTdh?=
 =?utf-8?B?VFNKOFFKQ0dPbHBGTCswVWZCd3FKSjVnMWs4T1RVb01qUmE5UUgyekRsMk80?=
 =?utf-8?B?TkVXUVoyWmpQMEVBM0tiYzZVbUlvWC9ucEVOdHZ0VXgyeTNhUmNRZjBDZzVa?=
 =?utf-8?B?YjNqNHBlR1hPZEpxU09WTTlJcWk1MS9QUkNhQWY0R0dxZkVVSUE5Mm1jS1cw?=
 =?utf-8?B?bzJ3YjgxZ0U1MUY4M0hVc3h4TmV2a2V1ZmtNZFBpNVBqVUhFc2pWdTJXcjl1?=
 =?utf-8?B?YWIvTjFoQUYxY0FvMUpLR2M1c05VcS9WdFhLMVZIWHlINVZsZjlrY0xqcEVn?=
 =?utf-8?B?b2FCd3FFVjlmMnpvekZuNkZ5bitaY2phV1FkdWl6QktWWUEzRkEwNUpvTDZz?=
 =?utf-8?B?T05UV210c3Rib0pUZmFyRzNQMmdGeDdtNmFCNzNxdjd4ZEcxVmxqZUs0NWlW?=
 =?utf-8?B?ZXFJK01UWDlJbFZyeEw5MlM0NDlWbEpmMjVSdDVsZndCNXJrR0JRQ09ZRUxz?=
 =?utf-8?B?VnFHby8vb041c3lsaUZpN0NDWDZYeGM0UGNmbUxvckwvSWFUbmVJRmFZUUoz?=
 =?utf-8?B?dGhBZUZuY2FRK01Xd0hTc2pUTzRXalF3TktXSGpVRXdxNlJaNlBGUlU5VFg3?=
 =?utf-8?B?TGdmd2NLRDVYbTFHR2NEMUdkbCswenJJZ3J6MVFGM3VBZGhWQW1OTFZZTDJv?=
 =?utf-8?B?S21RbjdBZFN2VjQveERYTHlUMUNtMUFtL3kzSmM3RTlOM2Y0LzJkY2I4b1hh?=
 =?utf-8?B?S0JEYWs0WDgvREM4SmcwelpEdDA2cmhjeHNZT2RkTi91TnBPTVprWmJ6Mzl4?=
 =?utf-8?B?RTQrVnB0azgzSzBaQmlnZ09tRHBWSThiRVN2M25lTWxwTnBva3gya3JQRHdZ?=
 =?utf-8?B?L3JBd2MwbU8xS1psSzdZdlc3aUtzQWJUK2d2UmVkckZUdlQrQ0ZRTHRSNmlX?=
 =?utf-8?B?bGQrY3FLTC96Y3V1akpLcmNVMjgzd1ZvZU16aHNyekF2SVo0QU5jVWRLSWMr?=
 =?utf-8?B?eUFSMFpaa1d0MGl4WUtaZExNQzkxdExROXBoZytybjFVY0JvdjlTejFzaHBx?=
 =?utf-8?B?NllIc2VuSnRIM01DaW1YU0wyZm5wazY4WHNKUGs5REovdUlVWXlBL3VSVlQz?=
 =?utf-8?B?YW92d2krTHYyc2RXc2sxbm9yK0l6bE5JY25xdWcrMDhpTU9TdUpJVUplVzlS?=
 =?utf-8?B?VHIzMDdob3RsTXIzczltN2N6aC8zRldxWWVKUkZ4THI3S1o5STNwamR6SDBt?=
 =?utf-8?B?eG52eTV0cW04cHg3RDFRUWxhdzVsRnNTVFlxN1VmdDBHdUFOWW12ZG1pSDhr?=
 =?utf-8?B?WTAzVnpWblM0L2FmT29sUFJUZ1lNS1huRWpjdjE1RHk2eW5lU3JsM0VjaDRY?=
 =?utf-8?B?OGtJYzB2aHZXbVdiMHZJWFZOakdaYmdmQTRpbFdpNFBnT09QQmdRQjFTUXRi?=
 =?utf-8?B?OWd3UEhXdWs1VURTNVhZbC9ZZjB4eG5ycGJBM3prYzVkUlZNVGc1WktUUTlI?=
 =?utf-8?B?bk1BMVlrRE5CbzVHbWhsbVBvQnFyTzlJNEQ0c1ZBbVNuZFRlbG9ZTXcxWENo?=
 =?utf-8?B?by9HZ2JkTFFMb1NaeUJTTDFFbUIxWTNpRktYYUFBSUQ3SHdzelBXcURXcUpv?=
 =?utf-8?B?YUNFYURVZmFZTlpiWVN4SXNmUWppYWNRelhzZ3NkR2NiMzNPYlRHUXhRSHUy?=
 =?utf-8?B?eHV3STBOL1l3UXVUY1pGQ3RCUGRDUjJ6ZmQzWXBxMEMxQ3dhSjJGYVI1QTJu?=
 =?utf-8?B?bVdmSGdBMENiRTJjN2FaL21TajkvWFF5THhCT0h6anYrOHc4cGlwUE10WkRT?=
 =?utf-8?B?SEFWRW9aU0prb29XNmtWaG8zQjdYcW1hTGNqTjZaWFJjd0ZvcFc5clFPU204?=
 =?utf-8?Q?rOYHF7J/S/rcnBy0=3D?=
X-Exchange-RoutingPolicyChecked:
	YVzBkWg0ARc/CYSGycX9+pArT0+Eq+KbUS73YCqTCxhfiesj+Dsq3jpHAlZ86xCcE6C41Pas6TP7z+KMsikJpjhzTWX40Ra1ZIIxRfLIIYT6URCjgRDNg4Ekh5pSeyPl4XbK70HVx9XGuftqflXW1H00f5v22m4ieIAGj4oEudtG7S/3Cy/sU6hdEGynczTECfDHYMcnjw5G67kYcDw5PWZNJJ2KXORm2t8QvoX4bdXQ2mp6cbDAbyHQ4KjOTUHyB2UwwgEiQeZPuWp5w6+pHXcQFfZm+hTiGgQrKZwFhrBZ6WpEF3FjmWMADselmFHjB/pHEcsqQ/iKGHb27Fh3xQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	otbC2t2JKphUttmcZ8ijMbclnc4W9jHdFbKm4pf5AKVqe8CJbX2Q2IRKZbMdaBiNR/mOqPzJHwtAvcXLL7LHzBE6aa54shDj4Q1dEe8YZLxqRvf152MHlndwZ4YQKh6AzKqZc3z5nhfxVKWAwP6l1JNCcoBXbgCX0M6/z4hsGitbNnMedhXkTHjVlBKOUCFrC4UDWIdrUA/yFQYYYes5YmNJ7JN0ofZVARxJ5Xg7HxZbZ8TK9o5SHE3Zlphw40qsz+C3eAgmW1OLfKh08w/ztHeMsS3WwRPTnBxZAz7P45OVlgwjOr1R3TImt0OuzPa6LvivJwmbRp1INFICGfhTnRYE8RvPrm0z4ogBtZkaq8rhIoPRZhWfhe6bK1hFz55XBqwc74p3rMoO5mE2/y1I+j+FAMC2zGoy0s6ApJl0ISwLveFzXwwSmnzDAPwvzu+xSfurwDiQiH78rodjALgzcaZjbhmL76XJAD5IgwM3kUNYessY+Ei+CxIagRvKZd4cMLVDUgWod8O8GoRSPSCUjO/64t5sPbAyR+XVaBTbzwSDefs+5Bz8LqUJ+IYjWP/bU+1yxOvWf9QPGoCQlbJnuA8anuyT+k7onoig5l0QyK4lpCOQaK7cem94JroAcM2q
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e49b32c8-38ab-4d61-a99a-08df0cfc105f
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 16:21:25.8140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvf/9TpzbBliHP3ssFGQSPujdjmCsapoaWvYFOqgdMb63l0LQjdAMkte6Im9Fygy5Ab6p4c0EumWYPS6has+++sY+wNg7cxfBLrDrXM/foc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8154

Looks good,

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

