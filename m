From: Oliver Neukum <oneukum@suse.de>
Subject: Re: Ejected Nook (usb mass storage) prevents suspend
Date: Tue, 30 Jul 2013 21:26:38 +0200
Message-ID: <1375212398.17175.2.camel@linux-fkkt.site>
References: <Pine.LNX.4.44L0.1307301252590.1105-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52424 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab3G3T0k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jul 2013 15:26:40 -0400
In-Reply-To: <Pine.LNX.4.44L0.1307301252590.1105-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-usb@vger.kernel.org, Linux PM List <linux-pm@lists.linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, hare@suse.de

On Tue, 2013-07-30 at 13:00 -0400, Alan Stern wrote:

> That's why I said the patch would fix the immediate problem but it
> wasn't the best solution.  You do agree that the patch is correct, as
> far as it goes?

It will allow the system to sleep. But it seems to me that
a genuine error while flushing a drive's cache is one of the
few things actual worth aborting a system suspend for.

> If you would like to handle the problems in sd.c concerning the
> sync-cache and spin-down stuff, that will be fine with me.

Yes. The problem is not limited to USB.

	Regards
		Oliver




