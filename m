From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH/RFC] scsi LLD alpha ordering
Date: Sun, 27 Jun 2004 18:13:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040627181352.5a3b8770.rddunlap@osdl.org>
References: <20040627124106.0bcdf020.rddunlap@osdl.org>
	<20040627222637.GJ30334@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:57254 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264609AbUF1BTh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jun 2004 21:19:37 -0400
In-Reply-To: <20040627222637.GJ30334@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org

On Sun, 27 Jun 2004 23:26:37 +0100 Matthew Wilcox wrote:

| On Sun, Jun 27, 2004 at 12:41:06PM -0700, Randy.Dunlap wrote:
| > 1.  Puts SCSI drivers in more alpha order, but not totally,
| > because some of the platform-specific drivers are still grouped
| > together.
| > 2.  scsi/arm/Kconfig used a comment:
| >   "The following drivers are not fully supported"
| > This patch adds an ending comment:
| >   "End of drivers not fully supported"
| > so that someone reading the menu can know the end of the
| > unsupported drivers list.
| > 3.  Adds a "Platform/Machine-specific drivers" comment before
| > the platform-specific drivers are lsited.
| 
| Well, you made a mistake with (3) -- The SCSI_LASI700 driver (depends
| on GSC) is platform specific.

Yeah, I noticed that.  It was more of a "legacy" thing (i.e., leave
it where it is), but I'll gladly move it.

| More generally, I don't think we have any kind of consensus on how
| to organise this menu.  I'd like to see it organised by manufacturer
| (Adaptec, NCR/Symbios/LSI, Qlogic, etc), but I know not everyone agrees.
| Possibly the categories should be FC, parallel SCSI, serial ATA and then
| alphabetically within those categories.

Yes, that's the real question here.  Right now they begin as alpha
by manufacturer (almost), then there are some platform-specific drivers
mixed in, then there is a large mixmash of platform-specific drivers...

| I also don't think that the Transport Attributes menu needs to be
| alphabetical.  I'd be amazed if anyone actually used it.  Come to think
| of it, why are these user-selectable?  Surely they should be _only_
| implied by the drivers that use them?  If we do need to keep it, I think
| the question needs to be rephrased -- Parallel SCSI sounds like SCSI
| devices attached to the parallel port (eg Iomega ZIP).  Maybe "Normal
| SCSI Transport Attributes" or "Regular" or "Legacy" or "Antique" would
| be better ;-)

I dunno.  Maybe SCSI-1/2/3 ?  but I'll just drop that part of the patch.

--
~Randy
