From: Oliver Neukum <oneukum@suse.com>
Subject: Re: [PATCH] USB: storage: add "no SYNCHRONIZE CACHE" quirk
Date: Tue, 15 Dec 2015 12:34:31 +0100
Message-ID: <1450179271.17387.19.camel@suse.com>
References: <Pine.LNX.4.44L0.1512031320580.1324-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964966AbbLOLgd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2015 06:36:33 -0500
In-Reply-To: <Pine.LNX.4.44L0.1512031320580.1324-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, Jun Itou <itou_jun@infoseek.jp>, Markus Rathgeb <maggu2810@gmail.com>, Matt <vickm78@hotmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Dan Williams <dcbw@redhat.com>, brad <bradhaack@fastmail.us>

On Thu, 2015-12-03 at 13:36 -0500, Alan Stern wrote:
> This is an old problem, but it was never resolved and it still affects
> people (Bugzilla #89511).  In short, there are USB-(S)ATA bridges that
> claim to be write-back but don't support the SYNCHRONIZE CACHE
> command.  
> This causes errors when filesystems try to flush data out to the disk.

OK, maybe this is a stupid idea, but could we test the command as we
enumerate the slave and store the result?

	Regards
		Oliver


