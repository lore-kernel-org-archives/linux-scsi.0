From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/14] scsi: convert host_busy to atomic_t
Date: Fri, 25 Jul 2014 13:38:41 +0200
Message-ID: <20140725113841.GA3043@lst.de>
References: <1405678393-11497-1-git-send-email-hch@lst.de> <1405678393-11497-8-git-send-email-hch@lst.de> <yq1lhrmkovo.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1lhrmkovo.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 22, 2014 at 12:18:19AM -0400, Martin K. Petersen wrote:
> More nitpicking. In the two previous atomic conversion patches you kept
> %hu for the atomic_t. Here it's %d.

I'll fix it to use %d everywhere, given that's it's not an unsigned short
anymore.
