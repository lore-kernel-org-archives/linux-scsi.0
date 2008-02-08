From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [patch 03/13] mptbase: reset ioc initiator during PCI resume
Date: Thu, 7 Feb 2008 17:23:24 -0800
Message-ID: <20080208012324.GA3601@tree.beaverton.ibm.com>
References: <200802050752.m157qsni010694@imap1.linux-foundation.org> <1202431285.3171.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43837 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758825AbYBHBXh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Feb 2008 20:23:37 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m181NQRC017338
	for <linux-scsi@vger.kernel.org>; Thu, 7 Feb 2008 20:23:26 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m181NQuc264866
	for <linux-scsi@vger.kernel.org>; Thu, 7 Feb 2008 20:23:26 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m181NPU5009708
	for <linux-scsi@vger.kernel.org>; Thu, 7 Feb 2008 20:23:26 -0500
Content-Disposition: inline
In-Reply-To: <1202431285.3171.46.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

On Thu, Feb 07, 2008 at 06:41:25PM -0600, James Bottomley wrote:
> On Mon, 2008-02-04 at 23:53 -0800, akpm@linux-foundation.org wrote:
> > From: "Darrick J. Wong" <djwong@us.ibm.com>
> > 
> > It appears that the LSI SAS 1064E chip needs to be reset after a
> > suspend/resume cycle before the driver attempts further communications with
> > the chip.  Without this patch, resuming the chip results in this error
> > message being printed repeatedly and no more disk I/O.
> > 
> > mptbase: ioc0: ERROR - Invalid IOC facts reply, msgLength=0 offsetof=6!
> > 
> > So far it seems to fix suspend/resume on all the MPT Fusion cards I have
> > (SAS and U320 SCSI) but since I don't know the internals of that chip I
> > can't say for sure if this is a proper fix.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Ping on this, please Eric.

As far as I can tell, Eric isn't really involved with this patch
anymore, and handed it over to Sathya.Prakash@lsi.com.  I received email
from him (her?  Apologies, I'm not sufficiently familiar with Indian
names) this morning saying that a modified version of it would go out to
linux-scsi in a day or two.

--D
