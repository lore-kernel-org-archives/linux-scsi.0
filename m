From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic94xx IO errors with "escb_tasklet_complete: phy0:
	REQ_TASK_ABORT"
Date: Wed, 04 Oct 2006 16:11:17 -0500
Message-ID: <1159996277.3437.83.camel@mulgrave.il.steeleye.com>
References: <20061004164438.GC5091@rhun.haifa.ibm.com>
	 <20061004132929.A29689@florence.linkmargin.com>
	 <20061004205621.GF5091@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:54983 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751136AbWJDVNS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 17:13:18 -0400
In-Reply-To: <20061004205621.GF5091@rhun.haifa.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andy Warner <andyw@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2006-10-04 at 22:56 +0200, Muli Ben-Yehuda wrote:
> Is an old firmware version ("Razor_10a1") expected to work with the
> aic94xx in mainline? alternatively, is the new firmware version
> ("V17/10c6") expected to work with older aic94xx versions? if either
> is true, I can try that tomorrow to see if firmware version makes a
> difference with the bad aic94xx.

There's no dependence I know of.  The 10c6 firmware was described as
having fixes mostly in the SATA area.

If you want to construct your own firmware blob, use this build
environment:

http://www.kernel.org/pub/linux/kernel/people/jejb/aic94xx_sequencer_fw.tar.gz

You just drop in the aic94xx_seq_microcode.c file and point the
aic984xx_seq.h link to the right location, build main and run it.

James


