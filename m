From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 01/17] mptbase: reset ioc initiator during PCI resume
Date: Sun, 30 Mar 2008 11:22:06 -0500
Message-ID: <1206894126.4224.39.camel@localhost.localdomain>
References: <200803282148.m2SLmVkL012216@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37024 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953AbYC3QWK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 12:22:10 -0400
In-Reply-To: <200803282148.m2SLmVkL012216@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, djwong@us.ibm.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> From: "Darrick J. Wong" <djwong@us.ibm.com>
> 
> It appears that the LSI SAS 1064E chip needs to be reset after a
> suspend/resume cycle before the driver attempts further communications with
> the chip.  Without this patch, resuming the chip results in this error
> message being printed repeatedly and no more disk I/O.
> 
> mptbase: ioc0: ERROR - Invalid IOC facts reply, msgLength=0 offsetof=6!
> 
> So far it seems to fix suspend/resume on all the MPT Fusion cards I have
> (SAS and U320 SCSI) but since I don't know the internals of that chip I
> can't say for sure if this is a proper fix.

After a huge amount of wrangling, a fix for this which everyone agreed
to is upstream here:

commit 4d4109d0eb6930e59942d019980b83af679f187b
Author: Prakash, Sathya <sathya.prakash@lsi.com>
Date:   Fri Mar 7 16:19:50 2008 +0530

    [SCSI] mpt fusion: Power Management fixes for MPT SAS PCI-E controllers

James


