From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH] SCSI: Update ASC list
Date: Wed, 28 Feb 2007 20:22:37 +0300
Message-ID: <45E5BA5D.8010701@tls.msk.ru>
References: <yq14pp65ht4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:21100 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbXB1RpW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Feb 2007 12:45:22 -0500
In-Reply-To: <yq14pp65ht4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
[]
> --- scsi-misc-2.6.orig/drivers/scsi/constants.c
> +++ scsi-misc-2.6/drivers/scsi/constants.c
[]
>  static struct error_info additional[] =

static CONST struct error_info additional[]... ?
>  {
>  	{0x0000, "No additional sense information"},
[]

/mjt
