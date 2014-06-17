From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: scsi-mq
Date: Tue, 17 Jun 2014 16:27:52 +0200
Message-ID: <53A05068.4080702@acm.org>
References: <1402580946-11470-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1402580946-11470-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliot <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/12/14 15:48, Christoph Hellwig wrote:
> Bart and Robert have helped with some very detailed measurements that they
> might be able to send in reply to this, although these usually involve
> significantly reworked low level drivers to avoid other bottle necks.

In case someone would like to see the results of the measurements I ran,
these results can be found here:
https://docs.google.com/file/d/0B1YQOreL3_FxUXFMSjhmNDBNNTg.

Two important conclusions from the data in that PDF document are as follows:
- A small but significant performance improvement for the traditional
  SCSI mid-layer (use_blk_mq=N).
- A very significant performance improvement for multithreaded
  workloads with use_blk_mq=Y. As an example, the number of I/O
  operations per second reported for the random write test increased
  with 170%. That means 2.7 times the performance
  of use_blk_mq=N.

I think this means the scsi-mq patches are ready for wider use.

Bart.
