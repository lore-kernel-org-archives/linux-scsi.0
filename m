From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v8 01/25] scsi/atari_scsi: Don't select CONFIG_NVRAM
Date: Mon, 31 Dec 2018 08:44:07 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1812310839050.444@nippy.intranet>
References: <cover.1545784679.git.fthain@telegraphics.com.au>         <e68fcc3ec0a6cd4e14f763366d4d9445890b9b82.1545784679.git.fthain@telegraphics.com.au>         <20181228173846.Horde.z_zDEJN0rVd8tkt3HjYzmg2@messagerie.si.c-s.fr>        
 <alpine.LNX.2.21.1812291050330.152@nippy.intranet>         <a170720a-fe17-744d-790b-e258465bd75e@gmail.com>         <alpine.LNX.2.21.1812291327380.152@nippy.intranet>         <5e901432-65e2-c87b-31e3-36a394687a9a@gmail.com>        
 <CAK8P3a1J3sy55nd5QbxR5AjxkLyE-RE=bDNKB9sG27xx=mZ60A@mail.gmail.com>         <20181230185002.Horde.AdSknvcs4hP1Kh_T_Cos6w8@messagerie.si.c-s.fr> <1546193203.2844.9.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1546193203.2844.9.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: LEROY Christophe <christophe.leroy@c-s.fr>, Arnd Bergmann <arnd@arndb.de>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 30 Dec 2018, James Bottomley wrote:

> 
> That said, as has been pointed out, the current #ifdef has a failing 
> corner case when both are modular (because the code should then be 
> included).  The runtime macro that correctly expresses this is 
> IS_REACHABLE(CONFIG_NVRAM).
> 

No, in the case of CONFIG_NVRAM=m, the conditional code is deliberately 
excluded. This is discussed in the patch description. The convention on 
PPC32 is that device drivers drop support for NVRAM in this situation. 

I've adopted the PPC32 convention here because M68K drivers and PPC32 
drivers have to co-exist (I'm thinking of valkyriefb, but there are other 
examples).

-- 

> James
> 
> 
