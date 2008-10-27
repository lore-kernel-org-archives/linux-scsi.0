From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH 1/2] cciss: fix sysfs broken symlink regression
Date: Mon, 27 Oct 2008 21:32:22 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77884C025E85D0@GVW0547EXC.americas.hpqcorp.net>
References: <20081027210136.GA9438@roadking.ldev.net>
 <20081027142954.d63b4590.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:25608 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbYJ0VdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2008 17:33:06 -0400
In-Reply-To: <20081027142954.d63b4590.akpm@linux-foundation.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "jens.axboe@oracle.com" <jens.axboe@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Monday, October 27, 2008 4:30 PM
> To: Miller, Mike (OS Dev)
> Cc: jens.axboe@oracle.com; linux-kernel@vger.kernel.org;
> linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/2] cciss: fix sysfs broken symlink regression
>
> On Mon, 27 Oct 2008 16:01:36 -0500
> Mike Miller <mike.miller@hp.com> wrote:
>
> > Patch 1 of 2
> >
> > Regression introduced by commit
> 6ae5ce8e8d4de666f31286808d2285aa6a50fa40.
> > This patch fixes a broken symlink in sysfs that was
> introduced by the
> > above commit also called "cciss: remove redundant code." We
> broke it
> > in 2.6.27-rc on or about 20080804. Some installers are
> broken if this
> > symlink does not exist and they may not detect the logical drives
> > configured on the controller.
> > It does not require being backported into 2.6.26.x or
> earlier kernels.
>
> OK, thanks, I tagged it for 2.6.27.x.
>
> > Please consider this for inclusion.
> >
> > Andrew, do I need to resubmit 2 of 2? Or is that one still
> in your queue?
> >
>
> What's 2 of 2?
>
> cciss patches which I presently have queued are:
>
> cciss-fix-regression-firmware-not-displayed-in-procfs-again-an
d-again.patch

This is patch 2 of 2.

> cciss-new-hardware-support.patch
> cciss-fix-sysfs-broken-symlink-regression.patch
>
>
