From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: aic79xx U320 + e1000 Intel hangs on Idual Xeon 7505
Date: Wed, 9 Apr 2003 12:26:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D766@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr02.intel.com ([192.55.52.25]:18143 "EHLO
	caduceus.fm.intel.com") by vger.kernel.org with ESMTP
	id S263732AbTDITLB (for <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2003 15:11:01 -0400
Received: from talaria.fm.intel.com (talaria.fm.intel.com [10.1.192.39])
	by caduceus.fm.intel.com (8.11.6p2/8.11.6/d: outer.mc,v 1.51 2002/09/23 20:43:23 dmccart Exp $) with ESMTP id h39JFji01617
	for <linux-scsi@vger.kernel.org>; Wed, 9 Apr 2003 19:15:45 GMT
Received: from fmsmsxvs041.fm.intel.com (fmsmsxvs041.fm.intel.com [132.233.42.126])
	by talaria.fm.intel.com (8.11.6p2/8.11.6/d: inner.mc,v 1.28 2003/01/13 19:44:39 dmccart Exp $) with SMTP id h39JNqE13016
	for <linux-scsi@vger.kernel.org>; Wed, 9 Apr 2003 19:23:52 GMT
List-Id: linux-scsi@vger.kernel.org
To: 'Duncan Gibb' <duncangibb@uk.dmgworldmedia.com>, Rohit Gupta <rohit@davsys.com>
Cc: linux-scsi@vger.kernel.org

Duncan & Rohit,

What version of the aic79xx driver is in that kernel?  I hope it is >=
1.3.1?

Andy

-----Original Message-----
From: Duncan Gibb [mailto:duncangibb@uk.dmgworldmedia.com] 
Sent: Wednesday, April 09, 2003 11:48 AM
To: Rohit Gupta
Cc: linux-scsi@vger.kernel.org
Subject: Re: aic79xx U320 + e1000 Intel hangs on Idual Xeon 7505


A few days ago, you wrote:

RG> I am having system hangs when I place the U320 SCSI card and
RG> the Intel gigabit Server card (copper) on the same bus,
RG> specifically the 100 Mhz bus on the Intel 7505 chipset.

I have a similar setup to you in a machine I built last weekend.  It's
based on a SuperMicro X5DA8 board, which has all the bits you mention on
the motherboard.

The system seems stable, but I am experiencing frequent SCSI bus and
apparent subsystem lockups.

Channel A has only the swap disk attached.

Channel B is:

CD-RW(term enabled)----m/b----|----PCMCIAreader----Scanner----terminator

M/B term is disabled (Adaptec SCSIselect seems to do this in a way the
m/b jumpers don't).  | is a backplate where the bus goes from IDC50-int
to 50MD-ext.  All devices worked fine on an older PCI aic7xxx-based card
but this board does not have enough PCI slots to test in situ.

Scanning at 300dpi in greyscale works fine; colour gets part way and
kills the scsi.  Writing a CD kills the scsi.  SCSI death looks like the
attached portion of /var/log/messages.  Death appears to afflict only
one channel.  "dd if=/dev/sda of=/dev/null" still works at any rate.

I am currently using an unadulterated kernel 2.4.21-pre5-ac3, pending
getting something more recent to build (with ac97).  ide-scsi is also
loaded.

If you've found any way around this apparent problem, or anyone has and
ideas, please let me know.

Cheers


Duncan

