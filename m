From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/3] add a request_queue argument to scsi_cmd_ioctl()
Date: Wed, 28 Mar 2007 13:29:34 +0200
Message-ID: <20070328112934.GM3963@kernel.dk>
References: <20070320213111L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:54902 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbXC1Mr1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Mar 2007 08:47:27 -0400
Content-Disposition: inline
In-Reply-To: <20070320213111L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Tue, Mar 20 2007, FUJITA Tomonori wrote:
> bsg uses scsi_cmd_ioctl() for some SCSI/sg ioctl
> commands. scsi_cmd_ioctl() gets a request queue from a gendisk
> arguement. This prevents bsg being bound to SCSI devices that don't
> have a gendisk (like OSD). This adds a request_queue argument to
> scsi_cmd_ioctl(). The SCSI/sg ioctl commands doesn't use a gendisk so
> it's safe for any SCSI devices to use scsi_cmd_ioctl().

applied all 3


-- 
Jens Axboe

