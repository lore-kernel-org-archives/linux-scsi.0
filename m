From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [TRIVIAL] [TRIVIAL 2.6] drivers_scsi_mvme147.c: kill duplicate
	#include
Date: 20 May 2004 07:43:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085056987.1763.6.camel@mulgrave>
References: <1085035551.24929.141.camel@bach>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:55258 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265117AbUETMnL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 08:43:11 -0400
In-Reply-To: <1085035551.24929.141.camel@bach>
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Thu, 2004-05-20 at 02:08, Rusty Russell wrote:
> --- trivial-2.6.6-bk6/drivers/scsi/mvme147.c.orig	2004-05-20 15:59:33.000000000 +1000
> +++ trivial-2.6.6-bk6/drivers/scsi/mvme147.c	2004-05-20 15:59:33.000000000 +1000
> @@ -122,8 +122,6 @@
>  
>  #define HOSTS_C
>  
> -#include "mvme147.h"
> -
>  static Scsi_Host_Template driver_template = {
>  	.proc_name		= "MVME147",
>  	.name			= "MVME147 built-in SCSI",

Same for this.  HOST_C alters the behaviour of the second include.

James


