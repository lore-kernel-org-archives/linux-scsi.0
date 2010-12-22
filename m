From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2a/7] SCST core / sysfs interface
Date: Wed, 22 Dec 2010 13:41:35 +0100
Message-ID: <AANLkTik-WY5+KsVU_Y2WDFeXNRzjXUPwmp66e5x1Bk7B@mail.gmail.com>
References: <201012211105.49590.bvanassche@acm.org> <20101221190313.GB10717@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35561 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0LVMl4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2010 07:41:56 -0500
Received: by iyi12 with SMTP id 12so4014870iyi.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2010 04:41:56 -0800 (PST)
In-Reply-To: <20101221190313.GB10717@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, James.Bottomley@suse.de, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Vladislav Bolkhovitin <vst@vlnb.net>

On Tue, Dec 21, 2010 at 8:03 PM, Greg KH <gregkh@suse.de> wrote:
>
> On Tue, Dec 21, 2010 at 11:05:49AM +0100, Bart Van Assche wrote:
> > +#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
> > +
> > +static ssize_t scst_tgtt_trace_level_show(struct device_driver *drv, char *buf)
>
> debug files belong in debugfs, not sysfs, please move them.

Hello Greg,

Thanks for the feedback about Documentation/ABI. I will move the SCST
sysfs documentation over there - in fact it's something I should
already have done since you had already mentioned it in a previous
e-mail.

Regarding the "trace_level" attributes in sysfs: are you aware that
these are not only useful for kernel developers to debug the storage
target code itself but also for storage target users who want to find
out what a SCSI initiator is doing ? The "scsi", "mgmt" and
"flow_control" trace levels are examples of this. Sometimes users (who
are not SCST developers) have to enable these in order to find out
what a SCSI initiator is doing. Are you sure you want these to be
moved to debugfs ?

Bart.
