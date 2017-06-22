From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 0/4] g_NCR5380: PDMA fixes and cleanup
Date: Thu, 22 Jun 2017 23:11:37 +0200
Message-ID: <201706222311.38121.linux@rainbow-software.org>
References: <cover.1497528687.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1497528687.git.fthain@telegraphics.com.au>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thursday 15 June 2017 14:17:56 Finn Thain wrote:
> Ondrej, would you please test this patch series? One of your patches
> has been modified slightly and the two I wrote are untested.

Works only with HDD on non-DTC chips. CD-ROM hangs. DTC hangs even with HDD.
The PDMA code really needs to be fixed.

-- 
Ondrej Zary
