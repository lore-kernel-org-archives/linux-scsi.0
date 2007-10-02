From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [patch 16/17] mptbase: reset ioc initiator during PCI resume
Date: Tue, 2 Oct 2007 16:51:48 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70A0A78D@NAMAIL4.ad.lsil.com>
References: <200710022138.l92LcCeb023603@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:64174 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbXJBWyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 18:54:50 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200710022138.l92LcCeb023603@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, djwong@us.ibm.com

On Tuesday, October 02, 2007 3:38 PM,  Darrick J. Wong wrote:

> 
> It appears that the LSI SAS 1064E chip needs to be reset after a
> suspend/resume cycle before the driver attempts further 
> communications with
> the chip.  Without this patch, resuming the chip results in this error
> message being printed repeatedly and no more disk I/O.
> 
> mptbase: ioc0: ERROR - Invalid IOC facts reply, msgLength=0 
> offsetof=6!
> 
> So far it seems to fix suspend/resume on all the MPT Fusion 
> cards I have
> (SAS and U320 SCSI) but since I don't know the internals of 
> that chip I
> can't say for sure if this is a proper fix.
> 

I replied to this thread a couple times last week, and no response from
Darrick.   I doubt this is required becase the MESSAGE_UNIT_RESET is
issued from inside mpt_do_ioc_recovery.  I need some logs with debug
enabled.   Darrick did you see my email?

Eric  
