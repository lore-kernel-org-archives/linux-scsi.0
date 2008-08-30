From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi/sd: Fix size output in MB
Date: Sat, 30 Aug 2008 16:36:00 -0600
Message-ID: <20080830223600.GF1239@parisc-linux.org>
References: <48B9546B.4010004@simon.arlott.org.uk> <1220117091.3615.3.camel@localhost.localdomain> <20080830174516.GD1239@parisc-linux.org> <20080830225950.4828dcf6@mjolnir.drzeus.cx> <1220132749.3615.14.camel@localhost.localdomain> <20080831001314.694df795@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52995 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583AbYH3WgR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Aug 2008 18:36:17 -0400
Content-Disposition: inline
In-Reply-To: <20080831001314.694df795@mjolnir.drzeus.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Simon Arlott <simon@fire.lp0.eu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Aug 31, 2008 at 12:13:14AM +0200, Pierre Ossman wrote:
> On Sat, 30 Aug 2008 16:45:49 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > Does MMC have the 10^3 requirement like SCSI/ATA disks do, or can you
> > use 2^10 like standard computer stuff for capacities?
> 
> Some do, some don't. I prefer the 2^10 and MiB variants as it avoids
> ambiguity.

I think the most compelling reason for ensuring they're the same is
that you can plug these devices into both an MMC slot directly and a
card-reader and have them show up over USB.  You don't want the reported
capacity to change when you do that.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
