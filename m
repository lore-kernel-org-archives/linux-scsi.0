From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] fusion update to current APIs
Date: Sat, 12 Jun 2004 06:20:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk>
References: <20040531115229.GA16143@lst.de> <20040612003608.GA152454@sgi.com> <20040612034518.GN24864@parcelfarce.linux.theplanet.co.uk> <20040612051353.GA152829@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:42979 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264643AbUFLFUK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jun 2004 01:20:10 -0400
Content-Disposition: inline
In-Reply-To: <20040612051353.GA152829@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, Emoore@lsil.com, linux-scsi@vger.kernel.org

On Fri, Jun 11, 2004 at 10:13:53PM -0700, Jeremy Higdon wrote:
> On Sat, Jun 12, 2004 at 04:45:18AM +0100, Matthew Wilcox wrote:
> > ... then the midlayer needs to get fixed rather than have all this code
> > duplicated in a million different drivers with subtly different bugs in
> > each one.
> 
> That makes sense to me.  In fact, I think we could just fix it in sg.
> It's only a problem with the older sg interfaces that don't specify
> a direction.
[...]
> Something like this, where sg_direction() does what the host drivers
> are currently doing.  I haven't actually tried this yet, but I can
> code something up and give it a whirl if folks would like (I'm a little
> short on time tonight :-).

This looks like exactly the right approach to take.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
