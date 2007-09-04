From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] Update version information of ips driver
Date: Tue, 4 Sep 2007 16:27:44 +0200
Message-ID: <20070904142744.GC16016@stusta.de>
References: <20070904141626.GA9777@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39296 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753643AbXIDO1n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2007 10:27:43 -0400
Content-Disposition: inline
In-Reply-To: <20070904141626.GA9777@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Sep 04, 2007 at 04:16:26PM +0200, Bernhard Walle wrote:
> This patch just makes the version number in ips.c and ips.h consistent. It
> seems that this has been forgotten in a60768e2d43eb30a1adb8a119aeac35dc0d03ef6.

A better fix would be to no longer have two different places defining a 
version number.

> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> 
> ---
>  drivers/scsi/ips.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- a/drivers/scsi/ips.h
> +++ b/drivers/scsi/ips.h
> @@ -1175,9 +1175,9 @@ typedef struct {
>  #define IPS_VER_MAJOR_STRING "7"
>  #define IPS_VER_MINOR 12
>  #define IPS_VER_MINOR_STRING "12"
> -#define IPS_VER_BUILD 02
> -#define IPS_VER_BUILD_STRING "02"
> -#define IPS_VER_STRING "7.12.02"
> +#define IPS_VER_BUILD 05
> +#define IPS_VER_BUILD_STRING "05"
> +#define IPS_VER_STRING "7.12.05"
>  #define IPS_RELEASE_ID 0x00020000
>  #define IPS_BUILD_IDENT 761
>  #define IPS_LEGALCOPYRIGHT_STRING "(C) Copyright IBM Corp. 1994, 2002. All Rights Reserved."

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

