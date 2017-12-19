From: Borislav Petkov <bp@alien8.de>
Subject: Re: [-next PATCH 4/4] treewide: Use DEVICE_ATTR_WO
Date: Tue, 19 Dec 2017 19:54:08 +0100
Message-ID: <20171219185407.fdrcmrjbmzmhl72w@pd.tnic>
References: <cover.1513706701.git.joe@perches.com>
 <fa30f1ad73f76dafff816df40cacffe613aa2f48.1513706702.git.joe@perches.com>
 <20171219184441.ixxh757tl44qvk5l@pd.tnic>
 <1513709474.1234.66.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.skyhub.de ([5.9.137.197]:48998 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750798AbdLSSyQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Dec 2017 13:54:16 -0500
Content-Disposition: inline
In-Reply-To: <1513709474.1234.66.camel@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Thomas Falcon <tlfalcon@linux.vnet.ibm.com>, John Allen <jallen@linux.vnet.ibm.com>, Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>, linux-wimax@intel.com, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Tue, Dec 19, 2017 at 10:51:14AM -0800, Joe Perches wrote:
> > The reason for the code churn being?
> 
> Consistency for easier grep by use-type.

Please explain that in the commit message so that we know why it was
changed.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
