From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug 10226] BusLogic Flashpoint SCSI Adapter not working with
	x86_64 kernels
Date: Thu, 13 Mar 2008 12:45:37 -0400
Message-ID: <20080313164537.GA21995@infradead.org>
References: <bug-10226-10286@http.bugzilla.kernel.org/> <200803122125.50161.us-@gmx.de> <1205357733.2941.160.camel@localhost.localdomain> <200803130709.44066.us-@gmx.de> <20080313125508.GF613@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33365 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYCMQp7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Mar 2008 12:45:59 -0400
Content-Disposition: inline
In-Reply-To: <20080313125508.GF613@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ulrich Schweitzer <us-@gmx.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Thu, Mar 13, 2008 at 06:55:08AM -0600, Matthew Wilcox wrote:
> How does this look?  I've inverted the sense of the flashpoint config
> option and neatened up the PCI-less support while I was there.

I think it's a good start.  Long-term flashpoint should either die or
become a driver of it's own - these cards have very little in common
with the regular intelligent buslogic cards and if you look at the
driver it's full of if (flashpoint) in every major function.

