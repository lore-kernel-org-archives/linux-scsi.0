From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] lpfc: use %zd format string for size_t
Date: Mon, 17 Oct 2016 15:39:35 +0200
Message-ID: <20161017133934.wr5ukie7p5t7qvwa@linux-x5ow.site>
References: <20161017123605.2217411-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43439 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757366AbcJQNjh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 09:39:37 -0400
Content-Disposition: inline
In-Reply-To: <20161017123605.2217411-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, James Bottomley <JBottomley@Odin.com>, Sebastian Herbszt <herbszt@gmx.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Oct 17, 2016 at 02:35:46PM +0200, Arnd Bergmann wrote:
> A recent bugfix introduced a harmless warning in the lpfc driver:
> 
> drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_write_firmware':
> drivers/scsi/lpfc/lpfc_logmsg.h:56:45: error: format '%ld' expects argument of type 'long int', but argument 9 has type 'size_t {aka const unsigned int}' [-Werror=format=]
> 
> 'size_t' is always the same width as 'long' in the kernel, but the compiler
> doesn't know that. The %z modifier is what the standard expects to be
> used here, and this shuts up the warning.
> 
> Fixes: 679053c651fb ("scsi: lpfc: Fix fw download on SLI-4 FC adapters")
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
