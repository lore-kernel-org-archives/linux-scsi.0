From: Christoph Hellwig <hch@lst.de>
Subject: Re: remove exofs, the T10 OSD code and block/scsi bidi support V4
Date: Tue, 5 Feb 2019 18:16:28 +0100
Message-ID: <20190205171628.GA2129@lst.de>
References: <20190201075557.9249-1-hch@lst.de> <3be11773-5ea9-4c08-25a5-dc556ded2d6f@electrozaur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3be11773-5ea9-4c08-25a5-dc556ded2d6f@electrozaur.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <ooo@electrozaur.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com, Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 04, 2019 at 10:31:39PM +0200, Boaz Harrosh wrote:
> On 01/02/19 09:55, Christoph Hellwig wrote:
> > The only real user of the T10 OSD protocol, the pNFS object layout
> > driver never went to the point of having shipping products, and we
> > removed it 1.5 years ago.  Exofs is just a simple example without
> > real life users.
> > 
> > The code has been mostly unmaintained for years and is getting in the
> > way of block / SCSI changes, 
> 
> For the 4th time: Which ?

Speeding up the I/O path for example.  Making sense of SCSI
command allocation for another.  Having to deal with sense data
handling for the duplicate scsi command allocation as a third.
