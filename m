From: Jens Axboe <axboe@suse.de>
Subject: Re: SG_IO open flags are which
Date: Thu, 18 Dec 2003 10:47:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031218094743.GU2495@suse.de>
References: <1071506381.3389.22.camel@patibmrh9> <3FE121D3.6050300@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:46822 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264968AbTLRJrt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2003 04:47:49 -0500
Content-Disposition: inline
In-Reply-To: <3FE121D3.6050300@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Pat LaVarre <p.lavarre@ieee.org>, linux-scsi@vger.kernel.org

On Thu, Dec 18 2003, Douglas Gilbert wrote:
> the SG_IO ioctl came along in lk 2.4. The sg driver will only allow
> the following SCSI commands through if the file was opened O_RDONLY:
>   TEST_UNIT_READY
>   REQUEST_SENSE
>   INQUIRY
>   READ_CAPACITY
>   READ_BUFFER
>   READ_6
>   READ_10
>   READ_12
>   MODE_SENSE
>   MODE_SENSE_10
>   LOG_SENSE

I think that's bogus to attempt to put such vague restrictions on what
you can do with the open device. What purpose does it serve?!

> _not_ on the list. The SG_IO ioctl() found in block/scsi_ioctl.c
> does not have this restriction so you can issue any SCSI
> commands when /dev/sda, for example, is opened O_RDONLY.

Thankfully, and that's quite on purpose.

-- 
Jens Axboe

