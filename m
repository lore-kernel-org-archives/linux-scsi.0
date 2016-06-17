From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] scsi: wd7000: print sector number as 64-bit
Date: Fri, 17 Jun 2016 13:45:12 +0200
Message-ID: <8560621.hGLRx8ZoGo@wuerfel>
References: <201606170138.QVDnvLmx%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201606170138.QVDnvLmx%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday, June 17, 2016 1:36:52 AM CEST kbuild test robot wrote:
> 
> All warnings (new ones prefixed by >>):
> 
>    drivers/scsi/wd7000.c: In function 'mail_out':
>    drivers/scsi/wd7000.c:915:44: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>        any2scsi((unchar *) ogmbs[ogmb].scbptr, (int) scbptr);
>                                                ^
>    drivers/scsi/wd7000.c: In function 'wd7000_queuecommand_lck':
>    drivers/scsi/wd7000.c:1117:26: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>       any2scsi(scb->dataptr, (int) sgb);
>                              ^
>    drivers/scsi/wd7000.c:1121:4: warning: 'isa_page_to_bus' is deprecated [-Wdeprecated-declarations]
>    drivers/scsi/wd7000.c:1128:4: warning: 'isa_page_to_bus' is deprecated [-Wdeprecated-declarations]
>    drivers/scsi/wd7000.c: In function 'wd7000_diagnostics':
>    drivers/scsi/wd7000.c:1151:20: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>    drivers/scsi/wd7000.c:1236:46: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>    drivers/scsi/wd7000.c:1482:59: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

I'm pretty sure these are all preexisting warnings, and they don't show up
on ARM or x86.

	Arnd
