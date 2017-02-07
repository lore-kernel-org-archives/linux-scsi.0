From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: aacraid: avoid open-coded upper_32_bits
Date: Tue, 7 Feb 2017 14:05:29 +0100
Message-ID: <bec2386d-7934-e655-7d73-97f0da7dc2ec@suse.de>
References: <20170207125948.490095-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170207125948.490095-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Dave Carroll <David.Carroll@microsemi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/07/2017 01:59 PM, Arnd Bergmann wrote:
> Shifting a dma_addr_t right by 32 bits causes a compile-time warning when
> that type is only 32 bit wide:
> 
> drivers/scsi/aacraid/src.c: In function 'aac_src_start_adapter':
> drivers/scsi/aacraid/src.c:414:29: error: right shift count >= width of type [-Werror=shift-count-overflow]
> 
> This changes the driver to use the predefined macros consistently, including
> one correct but open-coded upper_32_bits() instance.
> 
> Fixes: d1ef4da8487f ("scsi: aacraid: added support for init_struct_8")
> Fixes: 423400e64d37 ("scsi: aacraid: Include HBA direct interface")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

The coolest thing with your patches is, one gets to know new cool
functions/macros.

Anyways looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
