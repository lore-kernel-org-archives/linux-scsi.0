From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 2.4] export scsi_finish_command ACK?
Date: Tue, 23 Mar 2004 11:18:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080058735.14308.0.camel@compaq.xsintricity.com>
References: <40604D8F.6080505@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51670 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262648AbUCWQWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2004 11:22:21 -0500
In-Reply-To: <40604D8F.6080505@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-03-23 at 09:45, Jeff Garzik wrote:
> Doug,
> 
> Can I get your ACK on the attached patch?

ACK.

> I am about to submit libata to Marcelo (again :)), and this export is 
> needed by all users of ->eh_strategy_handler, of which libata is one.
> 
> 	Jeff
> 
> 
> 
> ______________________________________________________________________
> diff -Nru a/drivers/scsi/scsi_syms.c b/drivers/scsi/scsi_syms.c
> --- a/drivers/scsi/scsi_syms.c	Tue Mar 23 09:43:29 2004
> +++ b/drivers/scsi/scsi_syms.c	Tue Mar 23 09:43:29 2004
> @@ -43,6 +43,7 @@
>  EXPORT_SYMBOL(scsi_do_cmd);
>  EXPORT_SYMBOL(scsi_command_size);
>  EXPORT_SYMBOL(scsi_ioctl);
> +EXPORT_SYMBOL(scsi_finish_command);
>  EXPORT_SYMBOL(print_command);
>  EXPORT_SYMBOL(print_sense);
>  EXPORT_SYMBOL(print_req_sense);
-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


