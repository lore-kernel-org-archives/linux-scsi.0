From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] 2.4.25-pre8: loss of SCSI I/O initiative
Date: Tue, 3 Feb 2004 10:07:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040203090738.GX11683@suse.de>
References: <OFA5E0980A.777ADFCB-ONC1256E2C.00131EB3-C1256E2E.0061B28C@de.ibm.com> <1075747729.3248.17.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:37289 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265954AbUBCJHv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2004 04:07:51 -0500
Content-Disposition: inline
In-Reply-To: <1075747729.3248.17.camel@compaq.xsintricity.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Martin Peschke3 <MPESCHKE@de.ibm.com>, Marcelo Tosatti <marcelo.tosatti@cyclades.com>, linux-scsi mailing list <linux-scsi@vger.kernel.org>, andmike@us.ibm.com, garloff@suse.de

On Mon, Feb 02 2004, Doug Ledford wrote:
> On Mon, 2004-02-02 at 12:42, Martin Peschke3 wrote:
> > 
> > 
> > Marcelo, Doug,
> > 
> > here is another patch, which corrects some 'loss of initiative' problems.
> 
> Hi Martin.  Both of the patches you posted touch areas of code that are
> also touched by some of the patches I'm merging for the everything
> tree.  So, Marcelo, whether or not to take these depends partially on
> your decision as to what to do with the other scsi patches we've got
> here and that SuSE has.  In particular, it's possible that the mlqueue
> patch that I haven't got in my 2.4-everything tree yet may very well
> obsolete the need for one of these, and another patch in our tree may
> obsolete the need for the other.  I'm not sure yet.  Anyway, just wanted
> to let you know that if you are considering the bigger set of SCSI
> patches (and yes, I'm sure you want to see them before you would ever
> say yes, I'm just not sure if you've already decided that your answer is
> "no") then both of these patches from Martin would have to be merged
> with the final product and might not be necessary in the end, or if they
> are necessary I'm sure they'll have a slightly different form.

The patches Martin sent could be merged before any pending bigger
merges - they are pretty straight forward. I'd rather not put smaller
changes like that into bigger trees and merge all of those at one time
if only because it doesn't exactly help bug finding...

So in my opinion, they should just go straight to Marcelo.

-- 
Jens Axboe

