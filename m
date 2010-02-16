From: "Caspar Smit" <c.smit@truebit.nl>
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues
Date: Tue, 16 Feb 2010 15:41:18 +0100 (CET)
Message-ID: <7746.87.210.74.220.1266331278.squirrel@ketsers.dhs.org>
References: <6B62480106F2B34D8404CF2FDAA4D9EF71F646BECA@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
    <alpine.DEB.1.10.1002161446470.4986@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:53420 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab0BPOlU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Feb 2010 09:41:20 -0500
In-Reply-To: <alpine.DEB.1.10.1002161446470.4986@uplift.swm.pp.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

So this patch replaces the november '09 patches?

( [PATCH 7/7]MVSAS: Compatible with the new libsas )
[PATCH 6/7]MVSAS: Enhanced hot plug handling
[PATCH 5/7]MVSAS:Optimization for DMA buffer
[PATCH 4/7]MVSAS:Make code more flexibe for different chip model.
[PATCH 3/7]MVSAS: bug fix with big endian
[PATCH 2/7]MVSAS:add supporting MSI feature
[PATCH 1/7]MVSAS: Update chip initialization

Those patches fixed the raid5/6 initialization issue were disks were
dropped during the creation of a raid set.
Is that fixed in this patch too?

Kind regards,
Caspar Smit

> On Tue, 16 Feb 2010, Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL
> Tech wrote:
>
>> From: Srinivas <satyasrinivasp@hcl.in>
>> Date: Mon, 15 Feb 2010
>> Subject: [PATCH]: Fix for hot plug handling and IO issues.
>> 	Added code for handling of hot-plugging drives and tape issues.
>>
>> Signed-off-by: Srinivas <satyasrinivasp@hcl.in>
>
> Tested-by: Mikael Abrahamsson <swmike@swm.pp.se>
>
> (If this tag is valid, couldn't really confirm).
>
> Anyhow, this patch is a huge step up from the stock 2.6.32 kernel, so I'd
> like to see this included in the next stable rebuild.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

