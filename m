From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sg descriptor sense cleanup lk 2.6.11-rc1-bk1
Date: Thu, 20 Jan 2005 11:15:26 +0000
Message-ID: <20050120111526.GD32550@infradead.org>
References: <41EBA3F9.8030305@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:24490 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262119AbVATLP0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 06:15:26 -0500
Content-Disposition: inline
In-Reply-To: <41EBA3F9.8030305@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James.Bottomley@SteelEye.com

On Mon, Jan 17, 2005 at 09:39:37PM +1000, Douglas Gilbert wrote:
> Continuation of descriptor sense data expansion to
> sg driver.
> 
> Next will be the sd driver which awaits a
> new utility function in constants.c to read the
> sense data information field for medium/hardware
> errors.
> 
> Changelog:
>   - expand sense data handling to descriptor format
>   - make module parameters visible in
>       /sys/modules/sg/parameters
>   - add "readable" SCSI commands: READ(16), REPORT LUNS,
>     SERVICE_ACTION_IN, RECEIVE_DIAGNOSTIC, READ_LONG
>     and MAINTENANCE_IN_CMD to list
> 
> Signed-off-by: Douglas Gilbert <dougg@torque.net>

+#ifndef MAINTENANCE_IN_CMD
+#define MAINTENANCE_IN_CMD 0xa3
+#endif

Shouldn't we put it into <scsi/scsi.h> ?

