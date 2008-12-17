From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: READ CAPACITY 16
Date: Wed, 17 Dec 2008 12:49:06 -0700
Message-ID: <20081217194906.GH19967@parisc-linux.org>
References: <20081217164210.GC19967@parisc-linux.org> <da824cf30812170950p393be2fq729e98e93edef5dc@mail.gmail.com> <20081217180640.GE19967@parisc-linux.org> <1229540692.3508.18.camel@localhost.localdomain> <20081217191135.GF19967@parisc-linux.org> <1229541249.3508.24.camel@localhost.localdomain> <20081217193237.GG19967@parisc-linux.org> <1229542617.3508.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47929 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbYLQTtH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2008 14:49:07 -0500
Content-Disposition: inline
In-Reply-To: <1229542617.3508.32.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org

On Wed, Dec 17, 2008 at 02:36:57PM -0500, James Bottomley wrote:
> On Wed, 2008-12-17 at 12:32 -0700, Matthew Wilcox wrote:
> > Are you willing to take a patch that sends RC16 for devices claiming
> > SCSI_2, and falls back to RC10 if that doesn't work?  Or shall I try to
> > implement algorithm D and talk to T10?
> 
> Not really ... SCSI_2 is where the problems are.  SCSI 3 would be much
> more acceptable.  Then you can add an inquiry passthrough to USB
> mangling for devices you need to work.

That works for me.  Best of all, I don't care about any USB devices
today, so I won't even have to do the second part!

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
