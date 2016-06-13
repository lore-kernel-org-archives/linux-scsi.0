From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH resend] USB: uas: Fix slave queue_depth not being set
Date: Mon, 13 Jun 2016 14:05:50 +0200
Message-ID: <1465819550.15666.23.camel@suse.com>
References: <1464679083-2914-1-git-send-email-hdegoede@redhat.com>
	 <1464679083-2914-2-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161071AbcFMMJk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2016 08:09:40 -0400
In-Reply-To: <1464679083-2914-2-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gerd Hoffmann <kraxel@redhat.com>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, stable@vger.kernel.org

On Tue, 2016-05-31 at 09:18 +0200, Hans de Goede wrote:
> Commit 198de51dbc34 ("USB: uas: Limit qdepth at the scsi-host level")
> removed the scsi_change_queue_depth() call from uas_slave_configure()
> assuming that the slave would inherit the host's queue_depth, which
> that commit sets to the same value.
> 
> This is incorrect, without the scsi_change_queue_depth() call the slave's
> queue_depth defaults to 1, introducing a performance regression.

Hans, may I ask what become of this patch? I don't see it in the queue.

	Regards
		Oliver


