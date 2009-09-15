From: Milan Kocian <milon@wq.cz>
Subject: Re: [PATCH] sr: consider the last written sector when determining
 media size
Date: Tue, 15 Sep 2009 09:05:03 +0200
Message-ID: <20090915070503.GB13228@ntm.vs.lam.cz>
References: <4AA07D8A.6090004@kernel.org>
 <4AAEBB7A.3060700@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AAEBB7A.3060700@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Milan Kocian <milan.kocian@wq.cz>, Jan Kara <jack@suse.cz>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 15, 2009 at 06:54:02AM +0900, Tejun Heo wrote:
> Tejun Heo wrote:
> > On certain cases, UDF disc doesn't report capacity correctly via
> > READ_CAPACITY but TOC or trackinfo contains valid information which
> > can be obtained using cdrom_get_last_written().  ide-cd considers both
> > values and uses the larger one.  Do the same in sr.  This fixes
> > bko#9668.
> > 
> >  http://bugzilla.kernel.org/show_bug.cgi?id=9668
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: Milan Kocian <milan.kocian@wq.cz>
> > Cc: Jan Kara <jack@suse.cz>
> 
> PING.
> 
> -- 
> tejun
> 

yes, works for me. You can add :

Tested-by: Milan Kocian <milan.kocian@wq.cz>

:-)

-- 
Milan Kocian
