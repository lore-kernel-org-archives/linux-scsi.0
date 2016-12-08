From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 0/4] g_NCR5380: Bug fix and some enhancements
Date: Thu, 8 Dec 2016 19:45:02 +0100
Message-ID: <201612081945.02906.linux@rainbow-software.org>
References: <cover.1480917789.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1480917789.git.fthain@telegraphics.com.au>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday 05 December 2016 07:07:19 Finn Thain wrote:
> This patch series is based on the one submitted recently by Ondrej Zary.
>
> This version has a different irq probing fix for HP C2502 boards and
> a more comprehensive patch to change the default irq parameter.
>
> It needs testing on actual ISA hardware.

Tested on HP C2502 (53C400A chip), Canon FG2-5202 (53C400 chip), DTC-3181L 
(DTCT-436P chip) and MS-PNR (53C400A chip) ISA cards - everything works fine!

Thanks.

Tested-by: Ondrej Zary <linux@rainbow-software.org>

BTW. The release-region fix (my previous patch 6/6) has disappeared somehow. 
Should I resubmit?

-- 
Ondrej Zary
