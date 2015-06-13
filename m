From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v7 7/9] snic:Add sysfs entries to list stats and trace
 data
Date: Sat, 13 Jun 2015 09:17:32 -0700
Message-ID: <1434212252.2208.4.camel@HansenPartnership.com>
References: <1432886649-12034-1-git-send-email-nmusini@cisco.com>
	 <1432886649-12034-8-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35366 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbbFMQRe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Jun 2015 12:17:34 -0400
In-Reply-To: <1432886649-12034-8-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>
Cc: linux-scsi@vger.kernel.org, hare@suse.de, boaz@plexistor.com, jthumshirn@suse.de, Sesidhar Baddela <sebaddel@cisco.com>

On Fri, 2015-05-29 at 01:04 -0700, Narsimhulu Musini wrote:
> +static const struct file_operations snic_stats_fops __read_mostly = {
> +	.owner	= THIS_MODULE,
> +	.open	= snic_stats_open,
> +	.read	= seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +};

Checkpatch hates this for obvious reasons: a const structure has to be
read only, not read mostly, so it's a section conflict.  I fixed it up,
but running the code through checkpatch would have flagged it as an
error.

James


