From: Christoph Hellwig <hch@infradead.org>
Subject: Re: aic7xxx woes in 2.5
Date: Mon, 16 Dec 2002 19:03:19 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021216190319.B10346@infradead.org>
References: <3DFC059A.9AA3F75F@digeo.com> <23290000.1039982976@aslan.btc.adaptec.com> <3DFD9F89.4B994586@digeo.com> <32310000.1040064745@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <32310000.1040064745@aslan.btc.adaptec.com>; from gibbs@scsiguy.com on Mon, Dec 16, 2002 at 11:52:26AM -0700
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Andrew Morton <akpm@digeo.com>, linux-scsi@vger.kernel.org

On Mon, Dec 16, 2002 at 11:52:26AM -0700, Justin T. Gibbs wrote:
> Against???  That's the whole problem with diffs.  Every person wants them
> against something different.

Best idea is usually latest official release or current BK tree.
I've put the output of bk export -tpatch -r1.981,1.982 (i.e. vs latest BK)
at http://verein.lst.de/~hch/aic7xxx-2.5.52.patch.gz


