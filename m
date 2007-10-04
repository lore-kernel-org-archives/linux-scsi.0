From: linas@austin.ibm.com (Linas Vepstas)
Subject: Re: [patch 02/17] PCI Error Recovery: Symbios SCSI base support
Date: Thu, 4 Oct 2007 12:32:37 -0500
Message-ID: <20071004173237.GG4338@austin.ibm.com>
References: <200710022138.l92Lc0sG023555@imap1.linux-foundation.org> <20071002214926.GY12049@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37949 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbXJDRdC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Oct 2007 13:33:02 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l94HX1b8025413
	for <linux-scsi@vger.kernel.org>; Thu, 4 Oct 2007 13:33:01 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l94HX1OW555128
	for <linux-scsi@vger.kernel.org>; Thu, 4 Oct 2007 13:33:01 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l94HWooC009164
	for <linux-scsi@vger.kernel.org>; Thu, 4 Oct 2007 13:32:51 -0400
Content-Disposition: inline
In-Reply-To: <20071002214926.GY12049@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: akpm@linux-foundation.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, willy@debian.org

On Tue, Oct 02, 2007 at 03:49:26PM -0600, Matthew Wilcox wrote:
> On Tue, Oct 02, 2007 at 02:38:00PM -0700, akpm@linux-foundation.org wrote:
> > From: Linas Vepstas <linas@austin.ibm.com>
> > 
> > Various PCI bus errors can be signaled by newer PCI controllers.  This
> > patch adds the PCI error recovery callbacks to the Symbios SCSI device
> > driver.  The patch has been tested, and appears to work well.
> 
> Linas and I have been discussing the problems with this patch.  I think
> we have a solution; we certainly have something in my tree that's
> acceptable to me; he'd jus like to test it before it's unleashed on the
> world.

Matthew, your fix was a patch on top of my patch ... I assume you want
to submit it that way, instead of reworking this patch?  

Anyway, I finally got a chance to run it yesterday, it worked fine.  
I'll try to make final coments in the other thread.

--linas
