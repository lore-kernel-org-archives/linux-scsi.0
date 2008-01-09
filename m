From: Andi Kleen <andi@firstfloor.org>
Subject: Re: AHCI finds disks; no /dev/sd inodes bound?
Date: Wed, 9 Jan 2008 18:49:45 +0100
Message-ID: <20080109174945.GB15346@one.firstfloor.org>
References: <c7bcbd620801082340j46839c22n3081c2f5ad6af0ff@mail.gmail.com> <p738x2zosmd.fsf@bingen.suse.de> <c7bcbd620801090921w1a784417wc8aa42ecb83d589b@mail.gmail.com> <1199899766.3493.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:59331 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbYAIRrN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 12:47:13 -0500
Content-Disposition: inline
In-Reply-To: <1199899766.3493.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jon Watte <jwatte@gmail.com>, Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org

On Wed, Jan 09, 2008 at 11:29:26AM -0600, James Bottomley wrote:
> 
> On Wed, 2008-01-09 at 09:21 -0800, Jon Watte wrote:
> > Yes, that turns out to be the case. Thanks for the quick sanity check!
> > I wonder if it's possible to magically turn that on when selecting
> > AHCI support in menuconfig? That way, it'd be harder for someone else
> > to make the same mistake.
> 
> We've had several discussions on this.  However, AHCI is used in a lot
> of systems for CD-ROM support only.

Those systems (servers) typically have enough memory to tolerate a few
extra KB of code without problems.  In fact most PCs these days have.

-Andi
