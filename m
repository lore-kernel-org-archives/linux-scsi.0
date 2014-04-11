From: Robert Jennings <rob@pochix.net>
Subject: Re: [PATCH] Update Maintainers for IBM Power 842, vscsi, and vfc
 drivers
Date: Fri, 11 Apr 2014 10:42:56 -0500
Message-ID: <53480D80.4080404@pochix.net>
References: <53459226.2070002@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:58087 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbaDKPm6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Apr 2014 11:42:58 -0400
Received: by mail-ob0-f173.google.com with SMTP id gq1so6235361obb.18
        for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2014 08:42:57 -0700 (PDT)
In-Reply-To: <53459226.2070002@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>, Linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512



On 04/09/2014 01:32 PM, Nathan Fontenot wrote:
> Update the MAINTAINERS file to indicate the current maintainers
> for the IBM Power 842 Compression driver, IBM Power Virtual SCSI
> driver and the IBM Power Virtual FC Driver.
> 
> Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>

Nathan, sorry I didn't take care of this before I gave up
rcj@linux.ibm.com.

Acked-by: Robert Jennings <rob@pochix.net>

> --- MAINTAINERS |   16 +++++++++++----- 1 file changed, 11 
> insertions(+), 5 deletions(-)
> 
> Index: linux/MAINTAINERS 
> ===================================================================
>
>
> 
- --- linux.orig/MAINTAINERS	2014-04-08 14:14:57.000000000 -0500
> +++ linux/MAINTAINERS	2014-04-08 14:25:29.000000000 -0500 @@ 
> -4358,7 +4358,7 @@ F:	drivers/crypto/nx/
> 
> IBM Power 842 compression accelerator -M:	Robert Jennings 
> <rcj@linux.vnet.ibm.com> +M:	Nathan Fontenot 
> <nfont@linux.vnet.ibm.com> S:	Supported F: 
> drivers/crypto/nx/nx-842.c F:	include/linux/nx842.h @@ -4374,12 
> +4374,18 @@ S:	Supported F:	drivers/net/ethernet/ibm/ibmveth.*
> 
> -IBM Power Virtual SCSI/FC Device Drivers -M:	Robert Jennings 
> <rcj@linux.vnet.ibm.com> +IBM Power Virtual SCSI Device Drivers
> +M: Nathan Fontenot <nfont@linux.vnet.ibm.com> L: 
> linux-scsi@vger.kernel.org S:	Supported -F:	drivers/scsi/ibmvscsi/
>  -X:	drivers/scsi/ibmvscsi/ibmvstgt.c +F: 
> drivers/scsi/ibmvscsi/ibmvscsi* +F:	drivers/scsi/ibmvscsi/viosrp.h
>  + +IBM Power Virtual FC Device Drivers +M:	Brian King 
> <brking@linux.vnet.ibm.com> +L:	linux-scsi@vger.kernel.org +S: 
> Supported +F:	drivers/scsi/ibmvscsi/ibmvfc*
> 
> IBM ServeRAID RAID DRIVER P:	Jack Hammer
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTSA1/AAoJEHQMPZ7t8u1zbmwQAJXdfa1pObeOpukcuE924zGH
jKxeDsFSLSrkxltO7vVMZ/y2LsKJtOaNXy1GzSqX7y3TbaDv2hWYi+GcI6/AlBl+
cgTtMBfYmSUpyuOxEdDzkj4KRx8cF02V0ajCcCqkwTqwvDw5JWBR3/sjDTAvYhes
RzCv3Fl6F3Nf0ksTmmmUxlAmXUITH++4paYTZjrTW2N4YVUKVVzszr4K0dFqqqlW
Ffi/brOXPF7ItfdL4/cEm5j2cZPh/zMLHJb24z67WMmzhCIUELzBjlEFRsBalaz/
X+/pKED01KqNiOpWOLR7FKWZlNkiHV2ZB9QxoUAsepI/s94TxOK94nNHiT6feunG
5WQjrwiWYC2ntG/arNITtz/t+Hs0OKsAvT5mCQ4W+e+UzHB/61zeN3p2/avrA0H6
A33yN2BeHkUyR3ra4uzhn+Sx2nOJvArMNGrnw+LAxrxg17ymE7qGvAqGmDExeTRl
dLJv58B94QlchIgApuESQ4pLGvftvgT0bE/34DgWcTIBzQyTneTn5UTCOYR9h6hA
wpDPmujlt5aEEb2Pm11pJSJ7lvY8MoPOqyc7aHWPkz7t6qfKEdJ8IquRFAyqi+/6
MeiinUCUW1Tp4gif+sy+Dc8UIsMIniUDeyA0//aWZCkA+CfF++P89WWdke/c2t+X
otp+JW8ZqTgHZi1DUuiv
=TcEI
-----END PGP SIGNATURE-----
