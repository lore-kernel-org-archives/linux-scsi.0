From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] clean up scsi documentation
Date: Mon, 11 Nov 2002 15:54:33 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021111155433.A25131@infradead.org>
References: <200211111633.55526@bilbo.math.uni-mannheim.de> <20021111154256.A24447@infradead.org> <200211111650.06462@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211111650.06462@bilbo.math.uni-mannheim.de>; from eike@bilbo.math.uni-mannheim.de on Mon, Nov 11, 2002 at 04:50:06PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike@bilbo.math.uni-mannheim.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Mon, Nov 11, 2002 at 04:50:06PM +0100, Rolf Eike Beer wrote:
> > > here are my patches to clean up the scsi documentation. It is split in
> > > three parts:
> 
> [...]
> 
> > Sounds good to me.  Would be nice to separate the steps so BK notices
> > the file moves and keeps history.
> 
> Ok. What would be the best way of doing this? Move the files one by one? One 
> patch per file? Or a better script?

Let some BK user (e.g. james or me) do the move and then apply your fixup
patches.  We can do all moves as one cset without problems.
