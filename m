From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] bfa: turn bfa_mem_{kva,dma}_setup into inline functions
Date: Fri, 18 Nov 2016 14:22:03 +0100
Message-ID: <20161118132203.3og7fayqxk3xd5r2@linux-x5ow.site>
References: <20161116151445.3208739-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161116151445.3208739-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 16, 2016 at 04:14:27PM +0100, Arnd Bergmann wrote:
> These two macros cause lots of warnings with gcc-7:
> 
> drivers/scsi/bfa/bfa_svc.c: In function 'bfa_fcxp_meminfo':
> drivers/scsi/bfa/bfa_svc.c:521:103: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
> 
> Using inline functions makes them much more readable and avoids
> the warnings.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
