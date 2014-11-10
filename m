From: Meelis Roos <mroos@linux.ee>
Subject: Re: bisected regression: qla2xxx endianness on sparc64
Date: Mon, 10 Nov 2014 16:19:17 +0200 (EET)
Message-ID: <alpine.LRH.2.11.1411101617030.31442@siim2.ut.ee>
References: <alpine.DEB.2.03.1411022004230.3979@cyber.ee> <alpine.OSX.2.00.1411031508560.1960@administrators-macbook-pro.local> <alpine.LRH.2.11.1411032330370.19361@siim2.ut.ee> <20141110141555.GB12347@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141110141555.GB12347@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Christoph Hellwig <hch@lst.de>, qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> On Mon, Nov 03, 2014 at 11:32:14PM +0200, Meelis Roos wrote:
> > Yes. I took the same 3.18.0-rc1-00422-g2cc9188-dirty kernel that had 
> > just this patch reverted, it started the controller fine, detected disk, 
> > mounted root, started multiple tasks and then some time after startin 
> > exim it just hangs. This is consisten with what I saw during bisection.
> 
> Can you try to bisect this one as well?

I have tried for many evenings but it is not so easy. With current 
bisecting, I have lost good base version, even going back to 3.17 and 
3.16 breaks for now. I will try more after some days when I have an idea 
what did I change to break it (some conf option perhaps).

-- 
Meelis Roos (mroos@linux.ee)
