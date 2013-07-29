From: Oliver Neukum <oneukum@suse.de>
Subject: Re: Ejected Nook (usb mass storage) prevents suspend
Date: Mon, 29 Jul 2013 08:06:21 +0200
Message-ID: <1375077981.25230.5.camel@linux-fkkt.site>
References: <Pine.LNX.4.44L0.1307261629290.1028-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab3G2GGX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jul 2013 02:06:23 -0400
In-Reply-To: <Pine.LNX.4.44L0.1307261629290.1028-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-usb@vger.kernel.org, Linux PM List <linux-pm@lists.linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, hare@suse.de

On Fri, 2013-07-26 at 16:31 -0400, Alan Stern wrote:

> In addition to my earlier comment, the patch below should be applied.  
> It will fix your immediate problem, although not in the best way.

Alan,

I think your diagnosis is correct, but not the fix.
This is run even in the runtime case. We might lose
data if the flush is not done.

	Regards
		Oliver



