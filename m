From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: I/O Errors and no Partitions visible with QLogic failover driver and Storageworks array (MSA1500)
Date: Wed, 6 Jul 2005 10:49:41 -0700
Message-ID: <20050706174941.GB9992@plap.qlogic.org>
References: <42C856DC.9070506@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:43163 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262356AbVGFRtm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2005 13:49:42 -0400
Content-Disposition: inline
In-Reply-To: <42C856DC.9070506@gmx.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Heinzmann <Robert.Heinzmann@gmx.net>
Cc: linux-scsi@vger.kernel.org

On Sun, 03 Jul 2005, Robert Heinzmann wrote:

> 
> we observed some strange behaviour with the Qlogic failover driver 
> version 8.00.02 (Kernel 2.6.7) and MSA1500 storagework arrays.

I'd suggest you work the request through QLogic tech-support, as
the upstream qla2xxx driver has been stripped of all failover
components.

	http://www.qlogic.com/support/report_problem.asp

> We have a MSA1500 connected to two fabrics and 4 hosts connected to the 
> MSA1500, each with 2 Qlogic FC HBA's. Each HBA is connected to one 
> fabric. We have seen the following strange behaviour:
> 
> a) If we boot one machine and the HBA first found by the operating 
> system  is connected to the standby MSA1500 controller, the boot takes 
> very long and we get SCSI I/O errors (see below). After the boot no 
> partitions are visible on the array. If we issue blockdev --rescanpt on 
> the LUN's we see the partitions.
> 
> b) If we boot one machine and the HBA first found by the operating 
> system is connected to the active MSA1500 controller, the boot is very 
> quick (normal) and all partitions are visible after the boot.
> 
> Because I'm not such an kernel expert I thought of asking the SCSI 
> "gurus" on this list :). Who is responsible for scanning the parition 
> tables after inserting a new driver ?
>

The midlayer.

> Is this the driver itself or the 
> kernel ?

You're I/Os are being routed through the standby path -- please
contact, tech-support, as I believe this issue has been noted and
corrected.

Regards,
Andrew Vasquez
