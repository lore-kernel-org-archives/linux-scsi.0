From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH RESEND 2/7] megaraid_sas : Update MAINTAINERS and copyright
 information for megaraid drivers
Date: Fri, 21 Nov 2014 14:51:21 +0100
Message-ID: <546F4359.8050804@redhat.com>
References: <201411170957.sAH9viYE008947@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbaKUNvu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 08:51:50 -0500
In-Reply-To: <201411170957.sAH9viYE008947@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 11/17/2014 10:54 AM, Sumit.Saxena@avagotech.com wrote:
> Update MAINTAINERS list and copyright information for megaraid_sas driver.
>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> ---
>  MAINTAINERS                                 |    9 ++++++---
>  drivers/scsi/megaraid/megaraid_sas.h        |   16 +++++++++-------
>  drivers/scsi/megaraid/megaraid_sas_base.c   |   21 ++++++++++-----------
>  drivers/scsi/megaraid/megaraid_sas_fp.c     |   16 +++++++++-------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |   18 ++++++++++--------
>  drivers/scsi/megaraid/megaraid_sas_fusion.h |   16 +++++++++-------
>  6 files changed, 53 insertions(+), 43 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index aefa948..4c071f0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5830,10 +5830,13 @@ W:	http://linuxtv.org
>  S:	Odd Fixes
>  F:	drivers/media/parport/pms*
>  
> -MEGARAID SCSI DRIVERS
> -M:	Neela Syam Kolli <megaraidlinux@lsi.com>
> +MEGARAID SCSI/SAS DRIVERS
> +M:	Kashyap Desai <kashyap.desai@avagotech.com>
> +M:	Sumit Saxena <sumit.saxena@avagotech.com>
> +M:	Uday Lingala <uday.lingala@avagotech.com>
> +L:	megaraidlinux.pdl@avagotech.com
>  L:	linux-scsi@vger.kernel.org
> -W:	http://megaraid.lsilogic.com
> +W:	http://www.lsi.com
>  S:	Maintained
>  F:	Documentation/scsi/megaraid.txt
>  F:	drivers/scsi/megaraid.*
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index fe546e6..401f4a2 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -1,7 +1,8 @@
>  /*
>   *  Linux MegaRAID driver for SAS based RAID controllers
>   *
> - *  Copyright (c) 2003-2012  LSI Corporation.
> + *  Copyright (c) 2003-2013  LSI Corporation
> + *  Copyright (c) 2013-2014  Avago Technologies
>   *
>   *  This program is free software; you can redistribute it and/or
>   *  modify it under the terms of the GNU General Public License
> @@ -14,17 +15,18 @@
>   *  GNU General Public License for more details.
>   *
>   *  You should have received a copy of the GNU General Public License
> - *  along with this program; if not, write to the Free Software
> - *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   *
>   *  FILE: megaraid_sas.h
>   *
> - *  Authors: LSI Corporation
> + *  Authors: Avago Technologies
> + *           Kashyap Desai <kashyap.desai@avagotech.com>
> + *           Sumit Saxena <sumit.saxena@avagotech.com>
>   *
> - *  Send feedback to: <megaraidlinux@lsi.com>
> + *  Send feedback to: megaraidlinux.pdl@avagotech.com
>   *
> - *  Mail to: LSI Corporation, 1621 Barber Lane, Milpitas, CA 95035
> - *     ATTN: Linuxraid
> + *  Mail to: Avago Technologies, 350 West Trimble Road, Building 90,
> + *  San Jose, California 95131
>   */
>  
>  #ifndef LSI_MEGARAID_SAS_H
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 6c74a67..5fa6ce2 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1,7 +1,8 @@
>  /*
>   *  Linux MegaRAID driver for SAS based RAID controllers
>   *
> - *  Copyright (c) 2003-2012  LSI Corporation.
> + *  Copyright (c) 2003-2013  LSI Corporation
> + *  Copyright (c) 2013-2014  Avago Technologies
>   *
>   *  This program is free software; you can redistribute it and/or
>   *  modify it under the terms of the GNU General Public License
> @@ -14,22 +15,20 @@
>   *  GNU General Public License for more details.
>   *
>   *  You should have received a copy of the GNU General Public License
> - *  along with this program; if not, write to the Free Software
> - *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   *
> - *  FILE: megaraid_sas_base.c
> - *  Version : 06.805.06.00-rc1
> - *
> - *  Authors: LSI Corporation
> + *  Authors: Avago Technologies
>   *           Sreenivas Bagalkote
>   *           Sumant Patro
>   *           Bo Yang
> - *           Adam Radford <linuxraid@lsi.com>
> + *           Adam Radford
> + *           Kashyap Desai <kashyap.desai@avagotech.com>
> + *           Sumit Saxena <sumit.saxena@avagotech.com>
>   *
> - *  Send feedback to: <megaraidlinux@lsi.com>
> + *  Send feedback to: megaraidlinux.pdl@avagotech.com
>   *
> - *  Mail to: LSI Corporation, 1621 Barber Lane, Milpitas, CA 95035
> - *     ATTN: Linuxraid
> + *  Mail to: Avago Technologies, 350 West Trimble Road, Building 90,
> + *  San Jose, California 95131
>   */
>  
>  #include <linux/kernel.h>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
> index 685e6f3..246574b 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fp.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
> @@ -1,7 +1,8 @@
>  /*
>   *  Linux MegaRAID driver for SAS based RAID controllers
>   *
> - *  Copyright (c) 2009-2012  LSI Corporation.
> + *  Copyright (c) 2009-2013  LSI Corporation
> + *  Copyright (c) 2013-2014  Avago Technologies
>   *
>   *  This program is free software; you can redistribute it and/or
>   *  modify it under the terms of the GNU General Public License
> @@ -14,20 +15,21 @@
>   *  GNU General Public License for more details.
>   *
>   *  You should have received a copy of the GNU General Public License
> - *  along with this program; if not, write to the Free Software
> - *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   *
>   *  FILE: megaraid_sas_fp.c
>   *
> - *  Authors: LSI Corporation
> + *  Authors: Avago Technologies
>   *           Sumant Patro
>   *           Varad Talamacki
>   *           Manoj Jose
> + *           Kashyap Desai <kashyap.desai@avagotech.com>
> + *           Sumit Saxena <sumit.saxena@avagotech.com>
>   *
> - *  Send feedback to: <megaraidlinux@lsi.com>
> + *  Send feedback to: megaraidlinux.pdl@avagotech.com
>   *
> - *  Mail to: LSI Corporation, 1621 Barber Lane, Milpitas, CA 95035
> - *     ATTN: Linuxraid
> + *  Mail to: Avago Technologies, 350 West Trimble Road, Building 90,
> + *  San Jose, California 95131
>   */
>  
>  #include <linux/kernel.h>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index f37eed6..92f3354 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1,7 +1,8 @@
>  /*
>   *  Linux MegaRAID driver for SAS based RAID controllers
>   *
> - *  Copyright (c) 2009-2012  LSI Corporation.
> + *  Copyright (c) 2009-2013  LSI Corporation
> + *  Copyright (c) 2013-2014  Avago Technologies
>   *
>   *  This program is free software; you can redistribute it and/or
>   *  modify it under the terms of the GNU General Public License
> @@ -14,19 +15,20 @@
>   *  GNU General Public License for more details.
>   *
>   *  You should have received a copy of the GNU General Public License
> - *  along with this program; if not, write to the Free Software
> - *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   *
>   *  FILE: megaraid_sas_fusion.c
>   *
> - *  Authors: LSI Corporation
> + *  Authors: Avago Technologies
>   *           Sumant Patro
> - *           Adam Radford <linuxraid@lsi.com>
> + *           Adam Radford
> + *           Kashyap Desai <kashyap.desai@avagotech.com>
> + *           Sumit Saxena <sumit.saxena@avagotech.com>
>   *
> - *  Send feedback to: <megaraidlinux@lsi.com>
> + *  Send feedback to: megaraidlinux.pdl@avagotech.com
>   *
> - *  Mail to: LSI Corporation, 1621 Barber Lane, Milpitas, CA 95035
> - *     ATTN: Linuxraid
> + *  Mail to: Avago Technologies, 350 West Trimble Road, Building 90,
> + *  San Jose, California 95131
>   */
>  
>  #include <linux/kernel.h>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
> index 0d183d5..92ecd39 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
> @@ -1,7 +1,8 @@
>  /*
>   *  Linux MegaRAID driver for SAS based RAID controllers
>   *
> - *  Copyright (c) 2009-2012  LSI Corporation.
> + *  Copyright (c) 2009-2013  LSI Corporation
> + *  Copyright (c) 2013-2014  Avago Technologies
>   *
>   *  This program is free software; you can redistribute it and/or
>   *  modify it under the terms of the GNU General Public License
> @@ -14,19 +15,20 @@
>   *  GNU General Public License for more details.
>   *
>   *  You should have received a copy of the GNU General Public License
> - *  along with this program; if not, write to the Free Software
> - *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   *
>   *  FILE: megaraid_sas_fusion.h
>   *
> - *  Authors: LSI Corporation
> + *  Authors: Avago Technologies
>   *           Manoj Jose
>   *           Sumant Patro
> + *           Kashyap Desai <kashyap.desai@avagotech.com>
> + *           Sumit Saxena <sumit.saxena@avagotech.com>
>   *
> - *  Send feedback to: <megaraidlinux@lsi.com>
> + *  Send feedback to: megaraidlinux.pdl@avagotech.com
>   *
> - *  Mail to: LSI Corporation, 1621 Barber Lane, Milpitas, CA 95035
> - *     ATTN: Linuxraid
> + *  Mail to: Avago Technologies, 350 West Trimble Road, Building 90,
> + *  San Jose, California 95131
>   */
>  
>  #ifndef _MEGARAID_SAS_FUSION_H_

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

