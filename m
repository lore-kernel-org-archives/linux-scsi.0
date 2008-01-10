From: Oliver Neukum <oliver@neukum.org>
Subject: memory allocation in sg_io()
Date: Thu, 10 Jan 2008 13:33:10 +0100
Message-ID: <200801101333.12293.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out001.kontent.com ([81.88.40.215]:34885 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbYAJMc0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 07:32:26 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, SCSI development list <linux-scsi@vger.kernel.org>

Hi,

could you explain to me why this code can get away with allocating the
sense buffer on the stack?

static int sg_io(struct file *file, struct request_queue *q,
		struct gendisk *bd_disk, struct sg_io_hdr *hdr)
{
	unsigned long start_time;
	int writing = 0, ret = 0, has_write_perm = 0;
	struct request *rq;
	char sense[SCSI_SENSE_BUFFERSIZE];

	Regards
		Oliver
