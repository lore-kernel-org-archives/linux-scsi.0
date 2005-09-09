From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] permit READ DEFECT DATA in block/scsi_ioctl
Date: Fri, 9 Sep 2005 12:25:03 +0200
Message-ID: <20050909102501.GA25860@suse.de>
References: <43215EE4.6050003@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:84 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1030221AbVIIKY6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2005 06:24:58 -0400
Content-Disposition: inline
In-Reply-To: <43215EE4.6050003@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ballen@gravity.phys.uwm.edu

On Fri, Sep 09 2005, Douglas Gilbert wrote:
> The soon to be released smartmontools 5.34 uses the
> READ DEFECT DATA command on SCSI disks. A disk that
> has defect list entries (or worse, an increasing number
> of them) is at risk.
> 
> Currently the first invocation of smartctl causes this:
>    scsi: unknown opcode 0x37
> message to appear the console and in the log.
> 
> The READ DEFECT DATA SCSI command does not change
> the state of a disk. Its opcode (0x37) is valid for
> SBC devices (e.g. disks) and SMC-2 devices (media
> changers) where it is called INITIALIZE STATUS ELEMENT
> WITH RANGE and again doesn't change the external state
> of the device.
> 
> The patch is against lk 2.6.13 .
> 
> Changelog:
>   - mark SCSI opcode 0x37 (READ DEFECT DATA) as
>     safe_for_read
> 
> Signed-off-by: Douglas Gilbert <dougg@torque.net>

Fine with me.

Acked-by: Jens Axboe <axboe@suse.de>

-- 
Jens Axboe

