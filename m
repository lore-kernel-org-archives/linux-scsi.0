From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH 17/21] uas: Do not log urb status error on cancellation
Date: Wed, 10 Sep 2014 16:00:03 +0200
Message-ID: <1410357603.12706.27.camel@linux-fkkt.site>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
	 <1410349611-17573-18-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbaIJOAG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 10:00:06 -0400
In-Reply-To: <1410349611-17573-18-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Wed, 2014-09-10 at 13:46 +0200, Hans de Goede wrote:
> Check for both type of cancellation codes for sense and data urbs.

Then you should also check for -ESHUTDOWN (unplug of HC)

	Regards
		Oliver


