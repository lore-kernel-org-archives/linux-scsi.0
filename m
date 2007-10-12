From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/3] Update sysfs registration
Date: Fri, 12 Oct 2007 11:11:11 -0500
Message-ID: <1192205472.3342.25.camel@localhost.localdomain>
References: <46F25D13.6020305@suse.de>  <470F87B9.2070604@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43276 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757791AbXJLQLR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Oct 2007 12:11:17 -0400
In-Reply-To: <470F87B9.2070604@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>

On Fri, 2007-10-12 at 16:42 +0200, Hannes Reinecke wrote:
> Hi James,
> 
> I recently posted this patchset:
> 
> > these patches are a follow-up to the earlier patch from Kay Sievers named
> > "[SCSI] switch sdev sysfs attributes to default attributes".
> > It consists of three parts:
> > 
> > - PATCH 1/3: Rework scsi target allocation so that uevents will only
> >   be sent for existing targets
> > - PATCH 2/3: Add scsi_bus type to scsi_target and scsi_host, so they
> >   will show up in the scsi bus device listing.
> > - PATCH 3/3: switch scsi_host sysfs attributes to default attributes
> > 
> Did you have a chance to look at it?
> Will that be included in 2.6.24?
> 
> Some other pending sysfs patches are based on this, so we'd rather like to
> know where we stand ...

They're on the list of things needing careful review.  I'll hopefully
have some time in the next week to look through them.

James


