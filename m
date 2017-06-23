From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 0/4] g_NCR5380: PDMA fixes and cleanup
Date: Fri, 23 Jun 2017 22:13:59 +0200
Message-ID: <201706232214.00362.linux@rainbow-software.org>
References: <cover.1497528687.git.fthain@telegraphics.com.au> <alpine.LNX.2.00.1706231101230.2417@nippy.intranet> <alpine.LNX.2.00.1706232058220.10492@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1706232058220.10492@nippy.intranet>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Friday 23 June 2017 13:01:53 Finn Thain wrote:
> On Fri, 23 Jun 2017, I wrote:
> > Does this patch help? It should be applied on top of this series of 4.
>
> Sorry, I sent the wrong diff. Please try this patch instead.

Thanks, much better now: both HDD and CD-ROM seem to work on DTC and non-DTC 
chips. I get many of these messages with CD-ROM:
[  912.397076] generic_NCR5380_pread: No end dma signal (4096/4096)
[  913.141225] generic_NCR5380_pread: No end dma signal (4096/4096)

Maybe just remove this error message as in my original patch?

-- 
Ondrej Zary
