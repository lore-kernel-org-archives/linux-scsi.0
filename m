From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi_malloc fragmentation in 2.4.X
Date: Fri, 20 Dec 2002 20:36:29 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021220203629.A10546@infradead.org>
References: <70300000.1040416318@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70300000.1040416318@aslan.btc.adaptec.com>; from gibbs@btc.adaptec.com on Fri, Dec 20, 2002 at 01:31:58PM -0700
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@btc.adaptec.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Dec 20, 2002 at 01:31:58PM -0700, Justin T. Gibbs wrote:
> Are there any plans to correct the scsi_malloc fragmentation problems
> in 2.4.X?

Someone from Veritas had a patch for this, but unfortunately it seems
that one got left somewhere.

