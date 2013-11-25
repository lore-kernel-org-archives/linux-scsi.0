From: "George Spelvin" <linux@horizon.com>
Subject: Re: [mptscsih] Watchdog detected hard LOCKUP on cpu 0
Date: 25 Nov 2013 12:16:26 -0500
Message-ID: <20131125171626.13412.qmail@science.horizon.com>
References: <1385380914.2354.38.camel@dabdike>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:58063 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757300Ab3KYRQ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2013 12:16:28 -0500
In-Reply-To: <1385380914.2354.38.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux@horizon.com
Cc: DL-MPTFusionLinux@lsi.com, kashyap.desai@lsi.com, linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com

> The reason for the lack of replies is that no-one has much of an idea.

Yeah, I figured.

> This really looks like a hardware problem.  The qi_submit_sync() is
> suggestive: it's the intel IOMMU mapping call ... have you tried
> reproducing this with the iommu disabled?

4 hours in, and the rebuild 75% complete, with VT-d disabled in the BIOS.
"Where's the kaboom?"

Thanks, that makes a huge difference.

(VT-d has a bunch of individually controllable sub-options; I need to
explore them a bit more.)

I could also play with some iommu and intel_iommu options.


If it really is a hardware fault, I guess I'll give up on LSI and switch
to a Marvell 88SE9480 controller.

Much obliged!
