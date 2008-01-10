From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: memory allocation in sg_io()
Date: Thu, 10 Jan 2008 15:14:46 +0200
Message-ID: <47861A46.2030006@panasas.com>
References: <200801101333.12293.oliver@neukum.org> <47861815.5090008@panasas.com> <20080110130628.GA6258@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5746 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753283AbYAJN1P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 08:27:15 -0500
In-Reply-To: <20080110130628.GA6258@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Jan 10 2008 at 15:06 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Thu, Jan 10 2008, Boaz Harrosh wrote:
>> On Thu, Jan 10 2008 at 14:33 +0200, Oliver Neukum <oliver@neukum.org> wrote:
>>> Hi,
>>>
>>> could you explain to me why this code can get away with allocating the
>>> sense buffer on the stack?
>>>
>>> static int sg_io(struct file *file, struct request_queue *q,
>>> 		struct gendisk *bd_disk, struct sg_io_hdr *hdr)
>>> {
>>> 	unsigned long start_time;
>>> 	int writing = 0, ret = 0, has_write_perm = 0;
>>> 	struct request *rq;
>>> 	char sense[SCSI_SENSE_BUFFERSIZE];
>>>
>>> 	Regards
>>> 		Oliver
>>> -
>> where? what? do you mean in scsi_ioctl.c?
>> why not it's a synchronous call?
>> Do you mean 96 bytes is too big?
>> Do you mean DMA alignment and cache coherency? I'm working
>> on that for scsi devices.
> 
> I'm guessing aligment - so the answer is that 'it cannot get away with
> it'.
> 
I'm working on something for scsi.
Other block devices I don't know.

Boaz
