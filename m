From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for June 16 (osd)
Date: Tue, 16 Jun 2009 09:46:49 -0700
Message-ID: <4A37CC79.5000907@oracle.com>
References: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090615:


When
CONFIG_BLK_DEV_OSD=y
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set

build fails with

drivers/built-in.o: In function `class_osdblk_remove':
osdblk.c:(.text+0x55376): undefined reference to `osduld_put_device'
drivers/built-in.o: In function `class_osdblk_add':
osdblk.c:(.text+0x5564d): undefined reference to `osduld_path_lookup'
osdblk.c:(.text+0x5584d): undefined reference to `osduld_put_device'


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
