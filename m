From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 01/10] sg: Use dev_printk
Date: Fri, 12 Oct 2012 10:34:51 -0400
Message-ID: <50782A8B.5060508@interlog.com>
References: <1350030830-25614-1-git-send-email-hare@suse.de> <1350030830-25614-2-git-send-email-hare@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:57258 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab2JLOfO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 10:35:14 -0400
In-Reply-To: <1350030830-25614-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Kay Sievers <kay@vrfy.org>

On 12-10-12 04:33 AM, Hannes Reinecke wrote:
> Every sg device has a reference to the underlying scsi device, so
> this patch adds dev_printk() macros to have the messages prefixed
> with the correct device.
>
> Before:
> [772330.437378] sg_open: dev=2, flags=0x8800
> [772330.475425] sg_add_sfp: sfp=0xffff880429d3e000
>
> After:
> [  409.399888] sr 2:0:0:0: [sg2] sg_open: flags=0x8800
> [  409.446029] sr 2:0:0:0: [sg2] sg_add_sfp: sfp=0xffff880425856000
>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Doug Gilbert <dgilbert@interlog.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

