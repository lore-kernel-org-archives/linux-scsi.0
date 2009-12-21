From: "Caspar Smit" <c.smit@truebit.nl>
Subject: RE: Applying MVSAS Patch
Date: Mon, 21 Dec 2009 13:26:04 +0100 (CET)
Message-ID: <17117.87.210.74.220.1261398364.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:56775 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZLUM0L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2009 07:26:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Andy Yan <ayan@marvell.com>, Matt Tehonica <matt.tehonica@mac.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> On Sun, 20 Dec 2009, Andy Yan wrote:
>
>> Please don't apply the 7th patch with your kernel.
>
> Any chance of getting your patch applied to the stable kernel tree so it
might come into the regular distribution kernels?
>
> Might be good to hear if the other people applying it have had better
luck than me, for me the patches made the kernel freeze as soon as I did
anything with the mvsas device in question.

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
the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



