From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/2] Modified Maintainers list for MPT FUSION DRIVERS.
Date: Wed, 17 Feb 2016 03:53:54 -0800
Message-ID: <1455710034.4745.18.camel@perches.com>
References: <1455708326-7584-1-git-send-email-chaitra.basappa@broadcom.com>
	 <1455708326-7584-3-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455708326-7584-3-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-02-17 at 16:55 +0530, Chaitra P B wrote:
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>

Is this supposed to be a signed-off-by line?

A couple questions below.

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -6659,10 +6659,9 @@ S:	Maintained
> =A0F:	arch/arm/mach-lpc32xx/
> =A0
> =A0LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
> -M:	Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
> -M:	Praveen Krishnamoorthy=20
> -M:	Sreekanth Reddy <sreekanth.reddy@avagotech.com>
> -M:	Abhijit Mahajan <abhijit.mahajan@avagotech.com>
> +M:	Sathya Prakash <sathya.prakash@broadcom.com>
> +M:	Chaitra P B <chaitra.basappa@broadcom.com>
> +M:	Suganath Prabu Subramani=20
> =A0L:	MPT-FusionLinux.pdl@avagotech.com

Should this L: entry be changed?

> =A0L:	linux-scsi@vger.kernel.org
> =A0W:	http://www.lsilogic.com/support

This W: link seems broken/dead.
Should this be updated too?
