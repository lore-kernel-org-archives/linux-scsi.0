From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 1/3] SCSI Userspace Target: scsi-ml changes
Date: Sun, 05 Feb 2006 12:30:28 -0600
Message-ID: <1139164228.3017.14.camel@mulgrave.il.steeleye.com>
References: <1138157885.11692.32.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:17378 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751160AbWBESav (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Feb 2006 13:30:51 -0500
In-Reply-To: <1138157885.11692.32.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

OK ... I think this looks good enough to fix up in tree.  I just have
one minor quibble, so could you fix that and I'll put it in.

On Tue, 2006-01-24 at 20:58 -0600, Mike Christie wrote:
> @@ -31,6 +32,7 @@ struct scsi_pointer {
>  struct scsi_cmnd {
>         int     sc_magic;
>  
> +       struct Scsi_Host *shost;
>         struct scsi_device *device;

This is an unnecessary addition; you can get this from device->host.

Do you have a pointer for the userspace side of this yet?

James


