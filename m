From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 21 Dec 2002 08:30:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4093022704.1040484612@aslan.scsiguy.com>
References: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com>
 <176730000.1040430221@aslan.btc.adaptec.com>
 <20021221002940.GM25000@holomorphy.com>
 <190380000.1040432350@aslan.btc.adaptec.com>
 <20021221013500.GN25000@holomorphy.com>
 <223910000.1040435985@aslan.btc.adaptec.com>
 <20021221085510.A25881@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021221085510.A25881@infradead.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: William Lee Irwin III <wli@holomorphy.com>, Janet Morgan <janetmor@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> On Fri, Dec 20, 2002 at 06:59:46PM -0700, Justin T. Gibbs wrote:
>> Those were committed in separate changes into our local Perforce
>> repository, but I simply don't have the patience to replicate each
>> individual change in Perforce into a BK change.  Since all of the
>> Linux universe likes stuff in BK format, I do what I can to accomodate
>> them.
> 
> perforce can export unified diffs for each changeste-equivalent right?
> for the sgi ptools SCCS we use internally I wrote a simple script
> that extracts this diff, the commit message automates a BK checking
> with this.  This makes my job of keeping mainline in sync a lot easier
> and preserves the fine granuality.  And it works nicely although the
> internal tree has some additional noise in it (kdb and HSM support).

I go through this exact process every time that I release a minor
revision.  I just do it as a single CSET with the comments dispersed
into the individual files that the comments apply to.  If everyone is
really so opposed to using the individual file comment feature of BK,
it will actually make my life easier.  So just let me know what you
do or don't like about the latest CSET that I've committed:

http://linux-scsi.bkbits.net:8080/scsi-aic7xxx-2.5/cset@1.865.2.6?nav=index
.html|ChangeSet@-2d

>> If it wasn't such a pain to get stuff into the tree, you would see
>> smaller changesets.
> 
> Umm, getting smaller changesets in is not such a pain :)

I think you misunderstood me.  CSETs for 2.4.X have been available since
May of this year.  I again sent them in June.  Then July, etc. etc.
This would have allowed the 2.4.X branch to track almost every minor
revision of the aic7xxx driver.  Now with so much time having passed,
*of course* the changes are large.  From my own experience though, the
smaller changes haven't helped in getting them applied.  But since these
changes are in BK, I suppose the fact that there are now several CSETs
to be applied instead of just one or two doesn't matter much.  The
revision history is there for anyone to review in whatever granularity
they want.

--
Justin

