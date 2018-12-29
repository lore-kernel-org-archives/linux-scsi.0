From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v8 01/25] scsi/atari_scsi: Don't select CONFIG_NVRAM
Date: Sat, 29 Dec 2018 13:34:02 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1812291327380.152@nippy.intranet>
References: <cover.1545784679.git.fthain@telegraphics.com.au> <e68fcc3ec0a6cd4e14f763366d4d9445890b9b82.1545784679.git.fthain@telegraphics.com.au> <20181228173846.Horde.z_zDEJN0rVd8tkt3HjYzmg2@messagerie.si.c-s.fr> <alpine.LNX.2.21.1812291050330.152@nippy.intranet>
 <a170720a-fe17-744d-790b-e258465bd75e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a170720a-fe17-744d-790b-e258465bd75e@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: LEROY Christophe <christophe.leroy@c-s.fr>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-m68k@lists.linux-m68k.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

On Sat, 29 Dec 2018, Michael Schmitz wrote:

> 
> IS_BUILTIN(CONFIG_NVRAM) is probably what Christophe really meant to suggest.
> 
> Or (really going out on a limb here):
> 
> IS_BUILTIN(CONFIG_NVRAM) ||
> ( IS_MODULE(CONFIG_ATARI_SCSI) && IS_ENABLED(CONFIG_NVRAM) )
> 
> Not that I'd advocate that, for this series.
> 

Well, you are a maintainer for atari_scsi.c.

Are you saying that you want IS_BUILTIN(CONFIG_NVRAM) used here instead of 
ifdef?

OTOH, if you approve of the existing patch, please send your acked-by.

-- 

> Cheers,
> 
> 	Michael
> 
> 
> 
> 
