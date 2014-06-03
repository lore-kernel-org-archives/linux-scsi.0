From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 2/6] scsi: Implement sg_printk()
Date: Tue, 03 Jun 2014 09:32:20 -0400
Message-ID: <538DCE64.3020604@interlog.com>
References: <1401794577-102277-1-git-send-email-hare@suse.de> <1401794577-102277-3-git-send-email-hare@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54345 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbaFCNc1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2014 09:32:27 -0400
In-Reply-To: <1401794577-102277-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 14-06-03 07:22 AM, Hannes Reinecke wrote:
> Update the sg driver to use dev_printk() variants instead of
> plain printk(); this will prefix logging messages with the
> appropriate device.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: Doug Gilbert <dgilbert@interlog.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

