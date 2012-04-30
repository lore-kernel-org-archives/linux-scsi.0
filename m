From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Mon, 30 Apr 2012 16:04:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204301550090.1558-100000@iolanthe.rowland.org>
References: <518968.75200.qm@web100005.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60450 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756471Ab2D3UEs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Apr 2012 16:04:48 -0400
In-Reply-To: <518968.75200.qm@web100005.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 30 Apr 2012, Norman Diamond wrote:

> I wish I could get a broken Prolific bridge to test together with
> mine.

I just realized -- I have a buggy Prolific bridge here.  It's not the
same model as yours; the vendor ID is 0x067b but the product ID is
0x3507.

With the disk it is currently connected to, it does indeed report a 
capacity that is too large by 1, and the correct value is a multiple of 
63.

Alan Stern

