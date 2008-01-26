From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: on patch "[SCSI] relax scsi dma alignment"
Date: Sat, 26 Jan 2008 12:54:02 -0600
Message-ID: <1201373642.4387.0.camel@localhost.localdomain>
References: <479B80A3.5070207@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37202 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbYAZSyI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jan 2008 13:54:08 -0500
In-Reply-To: <479B80A3.5070207@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org


On Sat, 2008-01-26 at 19:49 +0100, Stefan Richter wrote:
> On commit 465ff3185e0cb76d46137335a4d21d0d9d3ac8a2:
> > This patch relaxes the default SCSI DMA alignment from 512 bytes to 4
> > bytes.  I remember from previous discussions that usb and firewire have
> > sector size alignment requirements, so I upped their alignments in the
> > respective slave allocs.
> [...]
> >  drivers/ata/libata-scsi.c      |    5 ++++-
> >  drivers/firewire/fw-sbp2.c     |    6 ++++++
> >  drivers/ieee1394/sbp2.c        |    6 ++++++
> >  drivers/scsi/scsi_lib.c        |    8 ++++++++
> >  drivers/usb/storage/scsiglue.c |   20 ++++++++++----------
> >  5 files changed, 34 insertions(+), 11 deletions(-)
> 
> No, FireWire only requires 4 bytes alignment.
> 
> I will channel a reversion of the firewire and ieee1394 hunks through
> linux1394-2.6.git for 2.6.26.

Don't revert, just put the numbers down to 4 (just in case someone
decides to lower the default SCSI alignment down from four ...).

James


