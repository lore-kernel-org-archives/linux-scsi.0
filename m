From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/6] Drivers: hv: vmbus: Implement multi-channel support
Date: Thu, 16 May 2013 00:01:30 -0400
Message-ID: <20130516040130.GB16728@kroah.com>
References: <1368655320-27599-1-git-send-email-kys@microsoft.com>
 <1368655354-27651-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53408 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab3EPEBW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 May 2013 00:01:22 -0400
Received: by mail-pa0-f51.google.com with SMTP id ld10so2104229pab.38
        for <linux-scsi@vger.kernel.org>; Wed, 15 May 2013 21:01:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1368655354-27651-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com

On Wed, May 15, 2013 at 03:02:29PM -0700, K. Y. Srinivasan wrote:
> +/*
> + * Retrieve the (sub) channel on which to send an outgoing request.
> + * When a primary channel has multiple sub-channels, we choose a
> + * channel whose VCPU binding is closest to the VCPU on which
> + * this call is being made.
> + */
> +struct vmbus_channel *get_outgoing_channel(struct vmbus_channel *primary)

That's a _very_ vague global symbol name you are adding to the kernel.
Same goes for the other functions you are adding here, please fix that,
and make them have the vmbus_ prefix, like everything else in this
patch.

So, sorry, no ack here.

greg k-h
