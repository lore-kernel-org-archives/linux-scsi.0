From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Tue, 17 Apr 2012 11:19:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204171114460.1364-100000@iolanthe.rowland.org>
References: <385068.36090.qm@web100007.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53000 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752987Ab2DQPTS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Apr 2012 11:19:18 -0400
In-Reply-To: <385068.36090.qm@web100007.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 17 Apr 2012, Norman Diamond wrote:

> Yes it does look like changing this bridge to CAPACITY_HEURISTICS
> from FIX_CAPACITY is likely to help a bit.

That's easy enough.

> I think that heuristics should also accept multiples of 63 even if
> the total is odd.  This doesn't solve everything but will probably
> help more.

Okay, if nobody objects.

> I think that handling of FIX_CAPACITY should check for multiples of
> 63 and report the apparent likelihood that FIX_CAPACITY probably
> wasn't the right setting for the bridge (if it's a bridge).  This
> doesn't solve everything but will probably help more.

The FIX_CAPACITY code runs in a different module.  It has no way to 
know whether the device is a bridge or not.

> The addition of TEST_CAPACITY doesn't solve everything but will
> probably help more.

That will require a certain amount of work, with the possibility of 
breaking some systems.  I'd rather not do it if there's no clear and 
pressing need.

Alan Stern

