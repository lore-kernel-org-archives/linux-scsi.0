From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 00/10] isci: core
Date: Tue, 15 Mar 2011 13:55:33 -0400
Message-ID: <20110315175533.GA8291@infradead.org>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
 <4D7FA620.10004@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49801 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab1CORzi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2011 13:55:38 -0400
Content-Disposition: inline
In-Reply-To: <4D7FA620.10004@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Dan Williams <dan.j.williams@intel.com>, james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Tue, Mar 15, 2011 at 01:47:12PM -0400, Jeff Garzik wrote:
> Let's get this driver into staging for 2.6.39, if it isn't going to
> hit the merge window for 2.6.39.
> 
> It would lame for such [presumably] high volume hardware to be in
> neither the main kernel, nor staging, at 2.6.39 release time.

What's the point of staging?  That just causes tons of poinless churn.
Linus has made it clear that normal high volume hardware drivers can go
in after the merge window.  So let's just polish it for another few
weeks and then put it in where it belongs.

