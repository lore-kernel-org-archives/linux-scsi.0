From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH 03/21] uas: Fix resetting flag handling
Date: Wed, 10 Sep 2014 15:40:29 +0200
Message-ID: <1410356429.12706.26.camel@linux-fkkt.site>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
	 <1410349611-17573-4-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaIJNkb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 09:40:31 -0400
In-Reply-To: <1410349611-17573-4-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Wed, 2014-09-10 at 13:46 +0200, Hans de Goede wrote:
> - Make sure we always hold the lock when setting / checking resetting
> - Check resetting before checking urb->status
> - Add missing check for resetting to uas_data_cmplt
> - Add missing check for resetting to uas_do_work

Why is the checking for stat and data inconsistent?

	Regards
		Oliver


