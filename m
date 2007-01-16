From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: Adaptect 9405w: What is the best solution?
Date: Tue, 16 Jan 2007 15:14:37 -0800
Message-ID: <1168989278.16470.22.camel@alexisLabtop>
References: <45A6195E.7020103@scanventure.no> <45A6570C.3090308@torque.net>
	 <45A6906D.3040805@us.ibm.com> <45A694A1.6010400@scanventure.no>
	 <45A69937.8030400@us.ibm.com> <45A6C33C.8060900@scanventure.no>
	 <45A81BBF.7050104@us.ibm.com> <45AA4A7B.7070607@scanventure.no>
	 <45ABE920.7090304@us.ibm.com>  <45ACDD6A.7040201@scanventure.no>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42664 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbXAPXOo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jan 2007 18:14:44 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0GNEgg2006782
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2007 18:14:42 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0GNEfX1301590
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2007 18:14:41 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0GNEfTN011514
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2007 18:14:41 -0500
In-Reply-To: <45ACDD6A.7040201@scanventure.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tarjei Huse <tarjei@nu.no>
Cc: linux-scsi@vger.kernel.org, "Tan, Dennis" <Dennis_Tan@adaptec.com>, "Chim, Ed" <ed_chim@adaptec.com>, "Wu, Gilbert" <Gilbert_Wu@adaptec.com>

Hi Tarjei,

I am glad that you a progressing forward!

<snip>
> >>
> >
> > Perhaps.  Could you send a full output?  It does not appear that the
> > aic94xx driver is loading at all...?
> >
> Duh again. I thought I had added the module to the initrd, but that
> didn't happen.
> 
> Ok, I'm one step further. Where can I get the binary firmware the
> adapter asks for?

The new sequencer has yet to be posted.  You can, however, use the old
f/w in the meantime by backing out patch #38:

http://sweaglesw.net/~djwong/docs/sas_ata-patches/38-aic94xx-v28-sequencer_2.patch

Regards,

Alexis

> 
> [    2.119258] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
> [    2.119335] ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 19 (level,
> low) -> IRQ 18
> [    2.119379] aic94xx: found Adaptec AIC-9405W SAS/SATA Host Adapter,
> device 0000:03:04.0
> [    2.119382] scsi0 : aic94xx
> [   12.158371] aic94xx: Failed to load sequencer firmware file
> aic94xx-seq-v28.bin, error -2
> [   12.158375] aic94xx: couldn't init seqs for 0000:03:04.0
> [   12.158376] aic94xx: couldn't init the chip
> 
> Kind regards,
> Tarjei
> 
> 
> > --D
> >
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

