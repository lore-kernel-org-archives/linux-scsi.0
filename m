From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: scsi-mq
Date: Fri, 13 Jun 2014 08:42:57 +0200
Message-ID: <539A9D71.7020504@acm.org>
References: <1402580946-11470-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1402580946-11470-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Robert Elliot <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/12/14 15:48, Christoph Hellwig wrote:
> The usage of blk-mq dramatically decreases CPU usage under all workloads going
> down from 100% CPU usage that the old setup can hit easily to usually less
> than 20% for maxing out storage subsystems with 512 byte reads and writes,
> and it allows to easily achieve millions of IOPS. Bart and Robert have
> helped with some very detailed measurements that they might be able to send
> in reply to this, although these usually involve significantly reworked low
> level drivers to avoid other bottle necks.

Thanks Christoph for writing up this excellent summary. In case anyone
is wondering which LLD changes Christoph is referring to: the tests I
ran myself were with an SRP initiator driver modified to use multiple
RDMA channels between initiator and target instead of a single channel.
I will post these changes for review on the linux-rdma mailing list as
soon as I have the time.

Bart.
