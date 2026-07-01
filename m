Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022084.outbound.protection.outlook.com [52.101.101.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE70425CEF;
	Wed,  1 Jul 2026 11:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.101.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782906259; cv=fail; b=KwwYtkPL60tW1Cye8zifRc/9B6SCHQnh+CysOXnuVA/0VdhaMbW3PjAYngnESsrrSM4/6iQE83omojgFF2TnDd6mAh5/imUVt19SC+ErtO0E7CjXnnD/qPSC8z17L5NLqDRU42uva/ZLLqEk4EwT+H+phG5aInyW9o/GtOPe7mc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782906259; c=relaxed/simple;
	bh=4hOZm21bDZVv7F+8We9ZKyzHUMtSorrCsWQyrAK4EJE=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:References:
	 In-Reply-To:MIME-Version; b=RjlX9twP2rNGSNkK4O3qUZbFE2rafpJYQ4tqZ9edMdgrw6CiBcKCu7BX5GJitAj6gDon8SwUyXetXn1oVfA8bApFSb4/jeNhYh7bELBSX6cYH/oeRg9q+kUBwq/6eCT7AVR3YOHtFsYo4WmLrFgK7C13Hqnjg96Uplh8CJrG+4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net; spf=pass smtp.mailfrom=garyguo.net; dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b=wq6knVO0; arc=fail smtp.client-ip=52.101.101.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=garyguo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=garyguo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=garyguo.net header.i=@garyguo.net header.b="wq6knVO0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RS+zU6vnSOsA4EDFD9tl9aB5/gPV4QqfdxSL8BygH6l2Hm8oXSZuISdcduWywX8m2NeULmJU8UWTFrGMmokMQFXG5ftAosol/jMivRkvpNTLIe8WdXcYnV5rMw97zmss9C3mpBWMGYgZIHAyBMyu6HoSlR6TkqEEnOxoOApsk+fRFVzKlLU+43ZVzD+o+dLUllM2Uc1OSGSdYj+e9YfUhsV7U3YZGEJS0VRu9zshYmD7C6ZuWfKXKNUnfWi6VV+cLWkm2BMah4ZnVoO4MLwo8x63AZdu+WSka9XtmlzI2jlPx/CfTqTRzE4uqoJCW/ifrIFV36kk9qkSTkRRHY2qIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwJkk5nTnDRm27oxVs5dW2PjkH0OJYXoR2duBU9wUJk=;
 b=loaJvCpqL0ml/vAN5WHm5M7xJUHYp2bHumX75nAVN5fs0bXNVk6moCrgOVa/8XiEJiTdh5TccV6NjoJhtFrF4nQdDupsDF8v9hsy3qkC+TuwO0Kk34vFkwVgcT7BWrdrUVELEBYmcDESD+ZDo4/p3JkmegTUlXwKGrE3zXADndRDUPPl4gWAKaveF+Jt6aEQRcVXex5Mv/8R0evXHtbfdqIlim2v5DsyGPwx2nL7VFfYOwZ3Hwuwb4knc5/UCIj7khRnYWNDsRzf/5FMNtMg7mf6gJgnLBsfgvNbd2gB9YyyJzA3Ry63up7L7wz7JSNl7XUWV2USfPj+SO5TqmitiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwJkk5nTnDRm27oxVs5dW2PjkH0OJYXoR2duBU9wUJk=;
 b=wq6knVO0Dz5fFvu2P2f34zO3IgtCmJzNTuNCX+tMjVIrcIxNB824kpCT6jrX/MwkXYU4uz8ZTMzimChdK3RbKPNlJwhcrjPBgsKgO8sTuB8amp2ywQbK20/47NvT/Lzea++CHYquwNZPSXYRuSCzVRIZMW3F4wy+Dy60685Ag0Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB9113.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:49b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 11:44:09 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.21.0159.018; Wed, 1 Jul 2026
 11:44:09 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 01 Jul 2026 12:44:08 +0100
Message-Id: <DJN7INDZVFWZ.1C2NSQTCYHQGE@garyguo.net>
Cc: <linux-scsi@vger.kernel.org>, <dlemoal@kernel.org>, <cassel@kernel.org>,
 <linux-ide@vger.kernel.org>, <linux-pci@vger.kernel.org>,
 <driver-core@lists.linux.dev>
Subject: Re: [PATCH v2 7/7] pci: fix UAF when probe runs concurrent to dyn
 ID removal
From: "Gary Guo" <gary@garyguo.net>
To: <sashiko-reviews@lists.linux.dev>, "Gary Guo" <gary@garyguo.net>
X-Mailer: aerc 0.21.0
References: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
 <20260630-pci_id_fix-v2-7-b834a98c0af2@garyguo.net>
 <20260701111052.3E04E1F00A3A@smtp.kernel.org>
In-Reply-To: <20260701111052.3E04E1F00A3A@smtp.kernel.org>
X-ClientProxiedBy: LO4P123CA0466.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::21) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO0P265MB9113:EE_
X-MS-Office365-Filtering-Correlation-Id: 91afab73-026d-461d-3170-08ded766100b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|23010399003|376014|1800799024|3023799007|6133799003|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	xW8hBtNQV76coriNBqlDsNZ25q+Rra1YNa1NqgZA5kpb/gX+/BIlwFjfImZo0ePW2P54Zs2cAcjChNdLRNHjMtViwGyQu0p54dCsEl+wY8zLbh4BGoGTQ77ERxMAkJdVKgXAVYQuT01qDgHr0Y6toYm6ub00npnxwSpH3uWgOkOamk+lILB8XMRjLhfnXJ/kfjx5RXUyH23XXNOz8rmBSEt2Jltgdp+L2JxRVu4slfOQpAMgCaz5vTPq8fPEq6zIOz43KwqqNW7Mu+/WmX+/U8VZo/pKE9N1FVjkmyQ2EtNEbciUJKQvbK9pP2d8B5yNKDmGrFEuuC8vXF4119wvymfG11isMNKN8+vWYlS5VBZq2aXYUVq21Pu7GzA7j1R7xpTmGuNS0qGvnnp83hRqJfE5bbqpyb5MIycwFRiTp74MX2H2n+lqW2GyMRc2tnEeWKzpcc3uQ7iFilVPD6IXwzk/JpSjyCOrPvxSmQqgjb3NDPF36UXmDCNe5alpVHqIXspwHRipbxszYK5Bvbio2woL96sBN/qAU9TDNQgq+2JywIOKU+9CXeWgVzeExFpWU0RTHsUbbEbWv7sM59eM4pdzFVIdoCzmUxOMVIFhNgw6iTfHkue3a7bVUDEkZJng5vGR4oQZgecEAHJ2AJ4H8SVfJtV2Q5dB6vK7c4zYG7A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(23010399003)(376014)(1800799024)(3023799007)(6133799003)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OExBTzlkQ1IrWHBjaFdDcVZ0WithVDhmU21lQTFvUy9hZk5qRnRkMFRvMlVs?=
 =?utf-8?B?V3g4TmFidW5TYnQ5VU9KWkNJdytWeDZ6cWVNb3lZNzd1aDBVOVl6WWNVU0Js?=
 =?utf-8?B?cFpWMXgyYk5Lcy8zSzRYdXZjMWJUWE93Vm4yQThoT3dIdkVXb2pzK0tHZW91?=
 =?utf-8?B?ZVIyMXVrSGEvM0pWc0NsVEhOT0ZrSjQzdUZRWURXckZiVW1kSEVrV1RMd0VB?=
 =?utf-8?B?WFoxbWVvWmF1RVlBWng1UWJJeTNjSnhMbjVwTHNlb3BUZVR0eU1YTzJjMVdW?=
 =?utf-8?B?d3lncHdKMWthSm5kQjlxeUZyMXZWcTVOY0RiU2cvZzFZcklrZnJZRXJEUGJu?=
 =?utf-8?B?VFFuVytwODdXUk9JMDA0RHAvWUZpSlpUYkF2bmNDVVhiN3Z4a2RIUC9JUEp6?=
 =?utf-8?B?SnZ0ZXp5UU5SaE1rdlZpazg1R1lMZ09oWVhsQUVCMWQyS0lEMk1rQWh1M3JM?=
 =?utf-8?B?aGZvMG5iUWovK0xEMlRuSXlnVFBIMnZoUXhFeEFmRmlqUDRIZ1QrZVo0d09M?=
 =?utf-8?B?UWNscmM2eU0rbExtZkJqakVTSEJKZWtyMzIzcWovWHlVcnd1eVJlcVBEWGFN?=
 =?utf-8?B?UUJ1MGM3N2xYZUlxMDE5T29WVnFsM3ZDQzhFTUVqRk9TeGdGbUROb2xTSUgr?=
 =?utf-8?B?T0lhMzlTMzB5cUVDMTNhcjllb1l3Vk5kSGl2Yk9JZzFuckNGczlKWmdwaGZm?=
 =?utf-8?B?K2xzT2FkVnVxSzRlaWZFNWRpWjdFeDNLck5wR3NkTmxOV0NkTWx1anZ2Rys2?=
 =?utf-8?B?VHVOcy9kV2d4QTB6S00zSzZOWks4cDV2clJlZjZkV3ZUaE1MMVVHMWJVVC9n?=
 =?utf-8?B?QVg5VVBIN0NkV1FIaFlVN29Obys5N2s3cm8zSE4vekpZTlU4V1VLWkJLZDJ4?=
 =?utf-8?B?cnJDaHp2dW9TYjJLWHA4SHpzeXZaeHo0dFhPaGVPdDRXKy9WK1NtODdsZXY4?=
 =?utf-8?B?WTVyZ3liakVXWjdYVnNNRnNDcE5NWjl2ekxwZmhMTjVnUkJMZ0pLL0U5U3BO?=
 =?utf-8?B?SzZ0bHNVZUNTUFRDQjJMKzh6NmpVdGlGb0ZuU2RqTXFpSHRobmt5d0NQU3B5?=
 =?utf-8?B?bUdnOEZUWVd3MHlqNURPaVYrVnA0WUJGS2JjbFNIMTQ3anA3OENkWC9idHNj?=
 =?utf-8?B?NUE5YTIvYjBpK0JCYnJpK2RDeHQ4QUREc2FJSitLVVA0S3ViVisxM3ZrT1Aw?=
 =?utf-8?B?bDZXM3NaWm5iR20wMUlhNW5oMFZNMWtKeCtNN0hJYnNuY3NsV3RDMm5WRGJX?=
 =?utf-8?B?R0V4eHBKN2ZLeFIzZWhOMlpEK1FRZ1VsYlJGT2JIdjE2R0lYemJnbzNLN3Uv?=
 =?utf-8?B?am5pZWgrSzR4RlN5amZ5Q0lNL1NiSFl0QTFpdWNXZ2JLSURHQ2RGTGF0UHVK?=
 =?utf-8?B?Q0JIZ1dvYWE2a0JrSjYzbHdzUk9CdzQzdDVwaUNrdms1Qzdhb1ZTNW5vZmgy?=
 =?utf-8?B?Y2d6WUx1ZEZvZWpVc2V1ZE1lNE0xWVZFUjJ5RDBxa3RlQTJPVXdDSnZHNjZC?=
 =?utf-8?B?aUhIdjB4RmFxSkRYeFFmbmQ2UXNRVDlRZFRYb1RFaDhwOFBzS05Ba1p2U0NX?=
 =?utf-8?B?NUdxa1NTRGlYZEd3TXBrcFJsY0ViaTl5UXhwYnZMZFVhQWNVbytuUlVmUmJS?=
 =?utf-8?B?VWI0VHBUenE2UEZxMnBGNjdiVTd4TTcvcG5EMmszYTk1T3NEdmpZSndsc1pk?=
 =?utf-8?B?Q1dhaTQwakR5QldxTjQvVllqNWp4RU85QXQvb0p3WmNmeDNNa3I0WGJ1Rms4?=
 =?utf-8?B?UkZSUVNsN1JIRy9vbTVvNkwwQTlSd3ZDMVAvdk9EQ0FRQ3g1aEZlc2VncEpv?=
 =?utf-8?B?aDRWckJHQ1JlbklKN3R2czlkai9NaEdIZFFIcVJ6RnhxcytlOU1UWWVNS09k?=
 =?utf-8?B?Y2tKaStuaE03ZVd1amN5SXZRYzF0VjRyUURRenN6ZzV1eW5Nc3c3Tzd3ZjQ4?=
 =?utf-8?B?WU51SEdTV3VDTHA2Yy84d0wwUzNRc3Bsc1VGcm1veFJhdmVJWnA4eHcxaUwy?=
 =?utf-8?B?SXR5cG5KWWsvVjJsdGZwSExiK1oySUJTS0tiZjFNbUNDWTlRZWM3aW80TGhm?=
 =?utf-8?B?aFpqanEyNThmbFNRT3UvYmFwRVBQUmRuVXRtNnFjdTNFNFVsQXEyaDlBdDlF?=
 =?utf-8?B?a3VTSlV2dE1ObHlOL3k5S2N2Y3FURy9lSHlBRHRFdWpSWDFZclhYVHpTWThO?=
 =?utf-8?B?V2hSTld3bXNFSFNtZlJtQUFsR3dxQ1pNOER0TXhQRVBQOFVWSXYrNURsVUFm?=
 =?utf-8?B?RDhHVk5zU1FHWUtOb1JvMGtIYmEydUV5SGNkeHBGSVhlS2E1SnVhSFZVZ1Uz?=
 =?utf-8?B?cURQcGcvSmxPRVU3Y085YTBnNmV6SVYya1JoeVNSeFJvcTBwYXExQT09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 91afab73-026d-461d-3170-08ded766100b
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 11:44:08.9866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: se06Eye4IRzU60nimWiSXbTiyW/BPknS9OB0RJRl4aOXQjM1XlqsrxNQK3OzwaSZ49UrXcRq+ITklsc4tCCwHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB9113

On Wed Jul 1, 2026 at 12:10 PM BST, sashiko-bot wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] The `id` parameter passed to PCI driver probe functions is now a=
 pointer to a stack-allocated variable, breaking drivers that rely on point=
er arithmetic to calculate indices or that cache the pointer.
> --
>
> commit 0cf7c75b08e81435f8eec9e2453a6dda8624a99b
> Author: Gary Guo <gary@garyguo.net>
> Subject: pci: fix UAF when probe runs concurrent to dyn ID removal
>
> This commit modifies the PCI matching logic to copy the matched device ID
> instead of returning a pointer to it. This ensures dynamic IDs are safely
> handled without requiring the lock to be held during probe.
>
> Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel=
.org/
>
>> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
>> --- a/drivers/pci/pci-driver.c
>> +++ b/drivers/pci/pci-driver.c
>
> [ ... ]
>
>> @@ -465,15 +470,14 @@ void pci_probe_flush_workqueue(void)
>>   */
>>  static int __pci_device_probe(struct pci_driver *drv, struct pci_dev *p=
ci_dev)
>>  {
>> -	const struct pci_device_id *id;
>> +	struct pci_device_id id;
>>  	int error =3D 0;
>> =20
>>  	if (drv->probe) {
>>  		error =3D -ENODEV;
>> =20
>> -		id =3D pci_match_device(drv, pci_dev);
>> -		if (id)
>> -			error =3D pci_call_probe(drv, pci_dev, id);
>> +		if (pci_match_device(drv, pci_dev, &id))
>> +			error =3D pci_call_probe(drv, pci_dev, &id);
>
> [Severity: High]
> Does passing a pointer to the stack-allocated id variable here break driv=
ers
> that rely on the pointer belonging to their static id_table?
>
> Some drivers compute an array index using pointer arithmetic against the
> provided id pointer. For example, in drivers/char/agp/amd-k7-agp.c:
>
> agp_amdk7_probe() {
>     ...
>     j =3D ent - agp_amdk7_pci_table;
>     dev_info(&pdev->dev, "AMD %s chipset\n",
>              amd_agp_device_ids[j].chipset_name);
>     ...
> }

I am amused both by creative ways that drivers make use of this ID (which, =
btw,
is completely wrong without this change already and would be OOB access for=
 any
dynamic ID or driver_override) and by the AI's ability to find them.

I'm now convinced that the drivers shouldn't be given the pci_device_id in =
the
first place but just the driver_data field, although it's going to be very
difficult to change all the drivers so that might never happen.

Best,
Gary

>
> Since the pointer now points to the stack frame in __pci_device_probe()
> rather than the static table, won't this pointer subtraction yield a
> wildly out-of-bounds index and cause a memory read fault during device
> probing?
>
>>  	}
>>  	return error;
>>  }


