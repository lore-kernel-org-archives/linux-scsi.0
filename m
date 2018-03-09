From: Tom Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH] scsi: jazz_esp, sun3x_esp: Pass struct device pointer in
 dma calls
Date: Fri, 9 Mar 2018 11:52:49 +0100
Message-ID: <20180309105249.GA6536@alpha.franken.de>
References: <S1751161AbeCGG4v/20180307065653Z+38@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <S1751161AbeCGG4v/20180307065653Z+38@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 07, 2018 at 05:56:41PM +1100, Finn Thain wrote:
> In jazz_esp and sun3x_esp, the esp_driver_ops methods pass esp->dev
> in dma api calls as if it was a pointer to a struct device. But
> it actually points to a struct platform_device. Fix this.
> 
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Looks good.

Reviewed-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
