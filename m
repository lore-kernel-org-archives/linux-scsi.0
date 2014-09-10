From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH 02/21] uas: Remove task-management / abort error
 handling code
Date: Wed, 10 Sep 2014 15:31:58 +0200
Message-ID: <1410355918.12706.24.camel@linux-fkkt.site>
References: <1410349611-17573-1-git-send-email-hdegoede@redhat.com>
	 <1410349611-17573-3-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaIJNcB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 09:32:01 -0400
In-Reply-To: <1410349611-17573-3-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Wed, 2014-09-10 at 13:46 +0200, Hans de Goede wrote:

> This commit removes the abort / lun-reset error handling paths, and also the
> taks-mgmt code since those are the only 2 task-mgmt users. Leaving only the
> (tested and testable) usb-device-reset error handling path in place.
> 
> Note I realize that this is somewhat of a big hammer, but currently people
> are seeing very hard to debug oopses with uas. First let focus on making uas
> work reliable, then we can later look into adding more fine grained error
> handling.

This hurts. But I suppose it is the conservative choice.

	Regards
		Oliver


