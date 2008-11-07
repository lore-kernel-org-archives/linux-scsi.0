From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: thin provisioned LUN support
Date: Fri, 7 Nov 2008 13:21:49 -0700
Message-ID: <20081107202149.GJ15439@parisc-linux.org>
References: <1226074002.8030.33.camel@localhost.localdomain> <1226074270.15281.50.camel@think.oraclecorp.com> <1226074710.8030.43.camel@localhost.localdomain> <1226078535.15281.63.camel@think.oraclecorp.com> <4914846C.5060103@redhat.com> <20081107183636.GB29717@mit.edu> <49148BDF.9050707@redhat.com> <20081107193503.GG29717@mit.edu> <yq1iqqz9uqt.fsf@sermon.lab.mkp.net> <20081107201913.GI29717@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35124 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYKGUVv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 15:21:51 -0500
Content-Disposition: inline
In-Reply-To: <20081107201913.GI29717@mit.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ric Wheeler <rwheeler@redhat.com>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Botto>

On Fri, Nov 07, 2008 at 03:19:13PM -0500, Theodore Tso wrote:
> Let's be just a *little* bit fair here.  Suppose we wanted to
> implement thin-provisioned disks using devicemapper and LVM; consider
> that LVM uses a default PE size of 4M for some very good reasons.
> Asking filesystems to be a little smarter about allocation policies so
> that we allocate in existing 4M chunks before going onto the next, and
> asking the block layer to pool trim requests to 4M chunks is not
> totally unreasonable.
> 
> Array vendors use chunk sizes > than typical filesystem chunk sizes
> for the same reason that LVM does.  So to say that this is due to
> purely a "broken firmware architecture" is a little unfair.

I think we would have a full-throated discussion about whether the
right thing to do was to put the tracking in the block layer or in LVM.
Rather similar to what we're doing now, in fact.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
