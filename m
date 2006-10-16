From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: aic94xx IO errors with "escb_tasklet_complete: phy0: REQ_TASK_ABORT"
Date: Mon, 16 Oct 2006 22:47:53 +0200
Message-ID: <20061016204753.GE5385@rhun.haifa.ibm.com>
References: <20061004164438.GC5091@rhun.haifa.ibm.com> <20061004132929.A29689@florence.linkmargin.com> <20061004205621.GF5091@rhun.haifa.ibm.com> <1159996277.3437.83.camel@mulgrave.il.steeleye.com> <20061016195122.GC5385@rhun.haifa.ibm.com> <1161028809.3433.26.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:50487 "EHLO
	mtagate3.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1161063AbWJPUr4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 16:47:56 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate3.uk.ibm.com (8.13.8/8.13.8) with ESMTP id k9GKlsxp173712
	for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2006 20:47:54 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9GKoOMs2113680
	for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2006 21:50:24 +0100
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9GKlsQZ019315
	for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2006 21:47:54 +0100
Content-Disposition: inline
In-Reply-To: <1161028809.3433.26.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andy Warner <andyw@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>

On Mon, Oct 16, 2006 at 03:00:09PM -0500, James Bottomley wrote:
> On Mon, 2006-10-16 at 21:51 +0200, Muli Ben-Yehuda wrote:
> > I finally got a chance to try aic94xx in 2.6.19-rc2-git with the
> > Razor_10a1 firmware. Works splendidly. This is fine as a workaround,
> > but I'd like to get it working with the latest firmware version as
> > well.
> 
> The sequencer firmware is a binary blob ... only adaptec know what's
> actually in it ...

Obviously, but I'm sure there's something we can do in the driver to
make it work on my system with the new firmware version as well as it
does with the old one.

Cheers,
Muli
