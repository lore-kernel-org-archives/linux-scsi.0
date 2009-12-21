From: "Caspar Smit" <caspar@ketsers.dhs.org>
Subject: RE: Applying MVSAS Patch
Date: Mon, 21 Dec 2009 13:25:32 +0100 (CET)
Message-ID: <17117.87.210.74.220.1261398332.squirrel@ketsers.dhs.org>
References: <67980649284293627495293095942659870934-Webmail@me.com>
    <20091216081301.59d1698e.randy.dunlap@oracle.com>
    <93017718277361587250366956065608636194-Webmail@me.com>
    <20091216090430.66b7f389.randy.dunlap@oracle.com>
    <29479280-86A1-4DF5-BA64-F2F0F1A4838B@mac.com>
    <20091216101617.a6499cad.randy.dunlap@oracle.com>
    <105495033028979535461096937726809251647-Webmail@me.com>
    <alpine.DEB.1.10.0912181519510.23464@uplift.swm.pp.se>
    <4D393076-4B36-49EC-AA69-ED0E52298943@mac.com>
    <5FF020A1CFFEEC49BD1E09530C4FF59505601D4D34@SC-VEXCH1.marvell.com>
    <alpine.DEB.1.10.0912211305180.23464@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:59911 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZLUMet (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2009 07:34:49 -0500
In-Reply-To: <alpine.DEB.1.10.0912211305180.23464@uplift.swm.pp.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Andy Yan <ayan@marvell.com>, Matt Tehonica <matt.tehonica@mac.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> On Sun, 20 Dec 2009, Andy Yan wrote:
>
>> Please don't apply the 7th patch with your kernel.
>
> Any chance of getting your patch applied to the stable kernel tree so it
> might come into the regular distribution kernels?
>
> Might be good to hear if the other people applying it have had better luck
> than me, for me the patches made the kernel freeze as soon as I did
> anything with the mvsas device in question.

Same here, after applying patches 1-6 at vanilla 2.6.32, the raid5/6
disconnecting of disks disappeared but still way too unstable. Kernel
panics when hotplugging exists and being able to run 3 controllers at the
same time is impossible.

Caspar

>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

