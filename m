From: Jens Axboe <axboe@suse.de>
Subject: Re: Assigning tag values?
Date: Fri, 18 Jul 2003 09:00:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030718070024.GV833@suse.de>
References: <3F174A6D.8050702@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:9132 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S271682AbTGRGpa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 02:45:30 -0400
Content-Disposition: inline
In-Reply-To: <3F174A6D.8050702@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Jul 17 2003, Jeff Garzik wrote:
> Is there a standard scsi way to assign tag values?
> 
> Can I use the block layer helpers, or do those not work for scsi?

Which kernel? In 2.5 you can get the scsi mid layer to do it for you
(via the block layer helpers), by calling scsi_activate_tcq(scsi_device,
depth). See scsi_tcq.h and 53c700.c for a working example.

-- 
Jens Axboe

