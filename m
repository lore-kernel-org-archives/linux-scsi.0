From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into the kernel
Date: Wed, 28 Sep 2005 11:27:12 -0500
Message-ID: <20050928162712.GA7615@us.ibm.com>
References: <Pine.LNX.4.10.10509271604510.14637-100000@master.linux-ide.org> <20050928113703.65626.qmail@web31806.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751355AbVI1Q1v@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050928113703.65626.qmail@web31806.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Andre Hedrick <andre@linux-ide.org>, Luben Tuikov <luben_tuikov@adaptec.com>, Jeff Garzik <jgarzik@pobox.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 28, 2005 at 04:37:03AM -0700, Luben Tuikov wrote:

> never ever going in.  Why else do you think IBM-ers agree with him that
> Linux SCSI doesn't need 64 bit LUNS?

Please stop repeating that, no one said we should *not* implement a 64 bit
LUN in linux scsi, and James posted a patch for 64 bit LUN. I posted a
clarification in response to your earlier postings, you seem to have
ignored or forgotten this post:

http://marc.theaimsgroup.com/?l=linux-scsi&m=112671847228275&w=2

I said:

"I am talking about the scsi spec, not the code. IMO linux scsi code
should support W_LUN and 64 bit LUN."

-- Patrick Mansfield
