From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 1/2] sdev_printk - scsi_device helper macro
Date: 31 Mar 2004 13:35:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080758108.1804.18.camel@mulgrave>
References: <200310071318.11847.dsteklof@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:24748 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262304AbUCaSfY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 13:35:24 -0500
In-Reply-To: <200310071318.11847.dsteklof@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Daniel Stekloff <dsteklof@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-10-07 at 16:18, Daniel Stekloff wrote:
> +#define sdev_printk(level, sdev, format, arg...) \
> +	printk(level "scsi <%s>: " format , (sdev)->sdev_gendev.bus_id , ## arg)
> +

OK, after six months, I've reconsidered on this one.

Make it #define to dev_printk() and it can go in.

James


