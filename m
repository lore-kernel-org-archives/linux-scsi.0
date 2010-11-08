From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFCv3 00/21] TCM Core and TCM_Loop patches for v2.6.37
Date: Mon, 8 Nov 2010 17:37:33 -0500
Message-ID: <20101108223733.GA26515@infradead.org>
References: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
 <20101108143952.GB22121@infradead.org>
 <1289251207.27226.59.camel@haakon2.linux-iscsi.org>
 <20101108214825.GA26609@infradead.org>
 <1289253869.27226.75.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1289253869.27226.75.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <joel.becker@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 08, 2010 at 02:04:29PM -0800, Nicholas A. Bellinger wrote:
> Hmmm, I recall asking Joel about this at some point back in 2008 and
> back then I believe configfs was still limited to a PAGE_SIZE.
> 
> Joel, any comments here on the usage of seq_file() w/ configfs..?

If fixing this would require configfs changes feel free to postponed it
for now.
