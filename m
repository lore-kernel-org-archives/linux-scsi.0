From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Tue, 10 Dec 2002 00:12:56 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021210001256.A9363@infradead.org>
References: <203630000.1039477998@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <203630000.1039477998@aslan.btc.adaptec.com>; from gibbs@scsiguy.com on Mon, Dec 09, 2002 at 04:53:18PM -0700
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Linus Torvalds <torvalds@transmeta.com>

On Mon, Dec 09, 2002 at 04:53:18PM -0700, Justin T. Gibbs wrote:
> http://people.FreeBSD.org/~gibbs/linux/RPM  # RPMs for popular distributions
> http://people.FreeBSD.org/~gibbs/linux/DUD  # Driver Update Diskettes
> http://people.FreeBSD.org/~gibbs/linux/SRC  # Source tarballs for 2.4.X and 
> 					      2.5.x relative to today's
> 					      bk trees.

Any chance you could provide patches?

I'm not sure how familar you are with BK, but if you didn't know it yet,
they are easily produced by

bk export -tpatch -r<last changeset from upstream>,<your last changeset>

