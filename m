From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [TRIVIAL] [TRIVIAL 2.6] drivers_scsi_gvp11.c: kill duplicate
	#include
Date: 20 May 2004 07:42:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085056948.2032.4.camel@mulgrave>
References: <1085035526.24935.140.camel@bach>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:49626 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265114AbUETMmi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 08:42:38 -0400
In-Reply-To: <1085035526.24935.140.camel@bach>
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Thu, 2004-05-20 at 02:07, Rusty Russell wrote:
>  #define HOSTS_C
>  
> -#include "gvp11.h"
> -
>  static Scsi_Host_Template driver_template = {
>  	.proc_name		= "GVP11",
>  	.name			= "GVP Series II SCSI",

This is definitely wrong.  I don't agree with the usage, but gvp11.h is
designed to be included twice.  The define of HOST_C above alters the
behaviour of the second include.

If you'd like to fix it correctly....

James


