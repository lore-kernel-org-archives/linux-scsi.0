From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 08/15] esp: fix section mismatch warning
Date: Fri, 03 Apr 2009 10:25:06 -0500
Message-ID: <1238772306.3359.17.camel@mulgrave.int.hansenpartnership.com>
References: <200903042006.n24K6CmE029281@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54732 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755701AbZDCPZL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2009 11:25:11 -0400
In-Reply-To: <200903042006.n24K6CmE029281@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, randy.dunlap@oracle.com, arobinso@nyx.net

On Wed, 2009-03-04 at 12:06 -0800, akpm@linux-foundation.org wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Not critical.
> 
> WARNING: drivers/char/esp.o(.text+0x278): Section mismatch in reference from the function show_serial_version() to the variable .init.data:serial_version
> The function show_serial_version() references
> the variable __initdata serial_version.
> This is often because show_serial_version lacks a __initdata
> annotation or the annotation of serial_version is wrong.
> 
> WARNING: drivers/char/esp.o(.text+0x27d): Section mismatch in reference from the function show_serial_version() to the variable .init.data:serial_name
> The function show_serial_version() references
> the variable __initdata serial_name.
> This is often because show_serial_version lacks a __initdata
> annotation or the annotation of serial_name is wrong.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Andrew J. Robinson <arobinso@nyx.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/char/esp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/char/esp.c~esp-fix-section-mismatch-warning drivers/char/esp.c
> --- a/drivers/char/esp.c~esp-fix-section-mismatch-warning
> +++ a/drivers/char/esp.c

That's not a SCSI driver (so linux-scsi isn't the right list).  esp is
some type of strange serial driver.

James


