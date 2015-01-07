From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: should we deprecate unmaintained isa-only drivers?
Date: Wed, 7 Jan 2015 06:34:32 -0800
Message-ID: <20150107143432.GA6542@infradead.org>
References: <20141230160616.GA29149@infradead.org>
 <201501062327.28830.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40379 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbAGOed (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2015 09:34:33 -0500
Content-Disposition: inline
In-Reply-To: <201501062327.28830.linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 06, 2015 at 11:27:28PM +0100, Ondrej Zary wrote:
> > note that the last two even drive the same hardware.  There is
> > significant cruft in all these, so dropping them would help
> > further maintainance of the SCSI midlayer.
> 
> I think I have a AHA-1542B ISA card so I can fix the aha1542 driver.

Can you simply test that it even works for now?  If that's the case
add yourself to MAINTAINERS for it, and and convert it away from using
scsi_module.c as a start so that we get rid of the 10 year deprecated
old-style host registration.
