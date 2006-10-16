From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: aic94xx IO errors with "escb_tasklet_complete: phy0: REQ_TASK_ABORT"
Date: Mon, 16 Oct 2006 21:51:22 +0200
Message-ID: <20061016195122.GC5385@rhun.haifa.ibm.com>
References: <20061004164438.GC5091@rhun.haifa.ibm.com> <20061004132929.A29689@florence.linkmargin.com> <20061004205621.GF5091@rhun.haifa.ibm.com> <1159996277.3437.83.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:56642 "EHLO
	mtagate4.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1750775AbWJPTv0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 15:51:26 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.13.8/8.13.8) with ESMTP id k9GJpPlm086172
	for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2006 19:51:25 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9GJrsfF2224372
	for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2006 20:53:54 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9GJpNEw002177
	for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2006 20:51:24 +0100
Content-Disposition: inline
In-Reply-To: <1159996277.3437.83.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andy Warner <andyw@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>

On Wed, Oct 04, 2006 at 04:11:17PM -0500, James Bottomley wrote:
> On Wed, 2006-10-04 at 22:56 +0200, Muli Ben-Yehuda wrote:
> > Is an old firmware version ("Razor_10a1") expected to work with the
> > aic94xx in mainline? alternatively, is the new firmware version
> > ("V17/10c6") expected to work with older aic94xx versions? if either
> > is true, I can try that tomorrow to see if firmware version makes a
> > difference with the bad aic94xx.
> 
> There's no dependence I know of.  The 10c6 firmware was described as
> having fixes mostly in the SATA area.
> 
> If you want to construct your own firmware blob, use this build
> environment:
> 
> http://www.kernel.org/pub/linux/kernel/people/jejb/aic94xx_sequencer_fw.tar.gz
> 
> You just drop in the aic94xx_seq_microcode.c file and point the
> aic984xx_seq.h link to the right location, build main and run it.

I finally got a chance to try aic94xx in 2.6.19-rc2-git with the
Razor_10a1 firmware. Works splendidly. This is fine as a workaround,
but I'd like to get it working with the latest firmware version as
well.

Cheers,
Muli
