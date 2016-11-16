From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] mvsas: fix command_active typo
Date: Wed, 16 Nov 2016 16:18:08 +0100
Message-ID: <20161116151808.5lnbops4jgmbi3f3@linux-x5ow.site>
References: <20161116150855.3083872-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161116150855.3083872-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 16, 2016 at 04:08:34PM +0100, Arnd Bergmann wrote:
> gcc-7 notices that the condition in mvs_94xx_command_active looks
> suspicious:
> 
> drivers/scsi/mvsas/mv_94xx.c: In function 'mvs_94xx_command_active':
> drivers/scsi/mvsas/mv_94xx.c:671:15: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]
> 
> This was introduced when the mv_printk() statement got added,
> and leads to the condition being ignored. This is probably harmless.
> 
> Changing '&&' to '&' makes the code look reasonable, as we check the
> command bit before setting and printing it.
> 
> Fixes: a4632aae8b66 ("[SCSI] mvsas: Add new macros and functions")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Looks reasonable,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
