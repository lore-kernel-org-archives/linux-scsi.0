From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2a/7] SCST core / sysfs interface
Date: Tue, 21 Dec 2010 11:03:13 -0800
Message-ID: <20101221190313.GB10717@suse.de>
References: <201012211105.49590.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab0LUTCa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 14:02:30 -0500
Content-Disposition: inline
In-Reply-To: <201012211105.49590.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, James.Bottomley@suse.de, Dmitry Torokhov <dmitry.torokhov@gmail.com>

On Tue, Dec 21, 2010 at 11:05:49AM +0100, Bart Van Assche wrote:
> +#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
> +
> +static ssize_t scst_tgtt_trace_level_show(struct device_driver *drv, char *buf)

debug files belong in debugfs, not sysfs, please move them.

thanks,

greg k-h
