From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: memory allocation in sg_io()
Date: Thu, 10 Jan 2008 15:05:25 +0200
Message-ID: <47861815.5090008@panasas.com>
References: <200801101333.12293.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:2889 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754040AbYAJNFi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 08:05:38 -0500
In-Reply-To: <200801101333.12293.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: axboe@kernel.dk, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Jan 10 2008 at 14:33 +0200, Oliver Neukum <oliver@neukum.org> wrote:
> Hi,
> 
> could you explain to me why this code can get away with allocating the
> sense buffer on the stack?
> 
> static int sg_io(struct file *file, struct request_queue *q,
> 		struct gendisk *bd_disk, struct sg_io_hdr *hdr)
> {
> 	unsigned long start_time;
> 	int writing = 0, ret = 0, has_write_perm = 0;
> 	struct request *rq;
> 	char sense[SCSI_SENSE_BUFFERSIZE];
> 
> 	Regards
> 		Oliver
> -
where? what? do you mean in scsi_ioctl.c?
why not it's a synchronous call?
Do you mean 96 bytes is too big?
Do you mean DMA alignment and cache coherency? I'm working
on that for scsi devices.

Boaz

