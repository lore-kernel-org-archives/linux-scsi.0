From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: aic94xx IO errors with "escb_tasklet_complete: phy0: REQ_TASK_ABORT"
Date: Thu, 5 Oct 2006 23:55:04 +0200
Message-ID: <20061005215504.GB14186@rhun.haifa.ibm.com>
References: <20061004164438.GC5091@rhun.haifa.ibm.com> <20061004132929.A29689@florence.linkmargin.com> <20061004205621.GF5091@rhun.haifa.ibm.com> <1159996277.3437.83.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:40973 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S932303AbWJEVzH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Oct 2006 17:55:07 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.13.8/8.13.8) with ESMTP id k95Lt525164988
	for <linux-scsi@vger.kernel.org>; Thu, 5 Oct 2006 21:55:05 GMT
Received: from d12av03.megacenter.de.ibm.com (d12av03.megacenter.de.ibm.com [9.149.165.213])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k95LvHfx3211504
	for <linux-scsi@vger.kernel.org>; Thu, 5 Oct 2006 23:57:17 +0200
Received: from d12av03.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av03.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k95Lt5lW013068
	for <linux-scsi@vger.kernel.org>; Thu, 5 Oct 2006 23:55:05 +0200
Content-Disposition: inline
In-Reply-To: <1159996277.3437.83.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andy Warner <andyw@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>

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

Thanks. I was hoping to get to it today but ended up chasing a genirq
bug in 2.6.19-rc1
(http://marc.theaimsgroup.com/?l=linux-kernel&m=116008372309485&w=2)
instead. I'll update when I'll know more. I saw some aic94xx patches
going by - should I be doing the experiments on an aic94xx other than
what's in mainline?

Cheers,
Muli
