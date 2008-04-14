From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: mptsas problem
Date: Mon, 14 Apr 2008 17:34:20 -0400
Message-ID: <20080414213420.GA13594@animx.eu.org>
References: <20080413204910.GA19651@animx.eu.org> <0631C836DBF79F42B5A60C8C8D4E8229FBE34D@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:37835 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbYDNVeg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2008 17:34:36 -0400
Content-Disposition: inline
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229FBE34D@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Richard Scobie <richard@sauce.co.nz>, linux-scsi@vger.kernel.org

Moore, Eric wrote:
> On Sunday, April 13, 2008 2:49 PM, Wakko Warner wrote:
> > > depth of 64 it may be queueing internally as well.  You could try
> > > lowering the lsi queue to 31 and seeing if it makes a difference.
> > 
> > IIRC, someone said the LSIs does queue in firmware.
> 
> It was probably me that told you that.   Anyways,  the lsiutil 100
> output you sent me last week indicated youre controller has NCQ
> disabled.     You need new firmware and controller chip rev in order to
> support NCQ.  You should contact LSI support to obtain which versions of
> firmware and chip rev that is required.   Meanwhile your controller will
> queuing commands for SATA, only sending one command across the wire at a
> time.   For SAS, you will not have this issue.

Does "chip rev" mean software/firmware or an actual chip?  Is there anyway
the driver can see this and set the queue_depth to 1?

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
