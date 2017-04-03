From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Apr 3 (scsi/lpfc)
Date: Mon, 3 Apr 2017 10:20:58 -0700
Message-ID: <79805f28-6d5c-fa04-4335-60a51b274250@infradead.org>
References: <20170403181304.13b3160f@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20170403181304.13b3160f@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, Linux-Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, james smart <james.smart@broadcom.com>, dick kennedy <dick.kennedy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On 04/03/17 01:13, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20170331:
> 

on i386:

when SCSI_LPFC=y and
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_BLK_DEV_NVME_SCSI=y
CONFIG_NVME_FABRICS=m
CONFIG_NVME_FC=m
CONFIG_NVME_TARGET=m

drivers/built-in.o: In function `lpfc_nvme_create_localport':
(.text+0x28ce6b): undefined reference to `nvme_fc_register_localport'
drivers/built-in.o: In function `lpfc_nvme_destroy_localport':
(.text+0x28d263): undefined reference to `nvme_fc_unregister_remoteport'
drivers/built-in.o: In function `lpfc_nvme_destroy_localport':
(.text+0x28d2d3): undefined reference to `nvme_fc_unregister_localport'
drivers/built-in.o: In function `lpfc_nvme_register_port':
(.text+0x28d576): undefined reference to `nvme_fc_register_remoteport'
drivers/built-in.o: In function `lpfc_nvme_unregister_port':
(.text+0x28d93c): undefined reference to `nvme_fc_unregister_remoteport'


so SCSI_LPFC depends on NVME_FC...



Reported-by: Randy Dunlap <rdunlap@infradead.org>

-- 
~Randy
