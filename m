From: Matthew Wilcox <willy@debian.org>
Subject: Re: [3/3] add MODULE_VERSION to drivers/scsi
Date: Thu, 22 Jul 2004 13:28:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040722122823.GC4227@parcelfarce.linux.theplanet.co.uk>
References: <20040721220111.GA16608@lists.us.dell.com> <20040721220258.GD16608@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:35218 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264236AbUGVM20
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jul 2004 08:28:26 -0400
Content-Disposition: inline
In-Reply-To: <20040721220258.GD16608@lists.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-scsi@vger.kernel.org, jgarzik@pobox.com

On Wed, Jul 21, 2004 at 05:02:58PM -0500, Matt Domsch wrote:
> You can import this changeset into BK by piping this whole message to
> '| bk receive [path to repository]' or apply the patch as usual.

> diff -Nru a/drivers/scsi/sym53c8xx_2/sym_version.h b/drivers/scsi/sym53c8xx_2/sym_version.h
> --- /dev/null	Wed Dec 31 16:00:00 196900
> +++ b/drivers/scsi/sym53c8xx_2/sym_version.h	2004-07-21 16:57:58 -05:00
> @@ -0,0 +1,53 @@
> +/*
> + * Device driver for the SYMBIOS/LSILOGIC 53C8XX and 53C1010 family 
> + * of PCI-SCSI IO processors.
> + *
> + * Copyright (C) 1999-2001  Gerard Roudier <groudier@free.fr>
> + *
> + * This driver is derived from the Linux sym53c8xx driver.
> + * Copyright (C) 1998-2000  Gerard Roudier
> + *
> + * The sym53c8xx driver is derived from the ncr53c8xx driver that had been 
> + * a port of the FreeBSD ncr driver to Linux-1.2.13.
> + *
> + * The original ncr driver has been written for 386bsd and FreeBSD by
> + *         Wolfgang Stanglmeier        <wolf@cologne.de>
> + *         Stefan Esser                <se@mi.Uni-Koeln.de>
> + * Copyright (C) 1994  Wolfgang Stanglmeier
> + *
> + * Other major contributions:
> + *
> + * NVRAM detection and reading.
> + * Copyright (C) 1997 Richard Waltham <dormouse@farsrobt.demon.co.uk>
> + *
> + *-----------------------------------------------------------------------------
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + * 1. Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions and the following disclaimer.
> + * 2. The name of the author may not be used to endorse or promote products
> + *    derived from this software without specific prior written permission.
> + *
> + * Where this Software is combined with software released under the terms of 
> + * the GNU Public License ("GPL") and the terms of the GPL would require the 
> + * combined work to also be released under the terms of the GPL, the terms
> + * and conditions of this License will apply in addition to those of the
> + * GPL with the exception of any terms or conditions of this License that
> + * conflict with, or are expressly prohibited by, the GPL.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
> + * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> + * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> + * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
> + * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> + * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
> + * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
> + * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
> + * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
> + * SUCH DAMAGE.
> + */
> +#define SYM_VERSION "2.1.18j"
> +#define SYM_DRIVER_NAME	"sym-" SYM_VERSION

Umm.  No.  This is ridiculous.  I'm not having a 51 line copyright message
with 2 lines of #define.  It's not even clear to me that these two lines
have artisitic merit.  How about putting these defines in sym_defs.h,
at the top?  It's already included in both sym_glue.c and sym_hipd.c by
being included by sym_glue.h.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
