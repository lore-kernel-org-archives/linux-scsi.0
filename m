From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] block: remove artifical max_hw_sectors cap
Date: Wed, 1 Oct 2014 14:12:58 -0700
Message-ID: <20141001211258.GB24820@infradead.org>
References: <1410044885-14893-1-git-send-email-hch@lst.de>
 <20141001130822.GA5362@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958CC7BAB@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958CC7BAB@G4W3202.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 01, 2014 at 06:59:34PM +0000, Elliott, Robert (Server Storage) wrote:
> One supporting example: A low limit interferes with creation of
> full stripe writes for RAID controllers.

Yes, both Linux mdraid and parity raids are often crippled by the
default.  The mdadm default of 512kb for each chunk combined with
the default limit very much guarantees a horrible out of the box
experience.
