From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Cannot get device recognized on a megaraid
Date: Mon, 24 Nov 2003 14:34:39 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031124143439.A18646@lists.us.dell.com>
References: <20031124163035.GK4399@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.us.dell.com ([143.166.224.162]:3248 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S263923AbTKXUfI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 15:35:08 -0500
Content-Disposition: inline
In-Reply-To: <20031124163035.GK4399@riseup.net>; from micah@riseup.net on Mon, Nov 24, 2003 at 10:30:35AM -0600
List-Id: linux-scsi@vger.kernel.org
To: Micah Anderson <micah@riseup.net>
Cc: linux-scsi@vger.kernel.org

> I've been fighting a megaraid card with one device, just trying to get
> it recognized. The card has the latest bios, the drive is in a RAID 0
> container.

What kernel and version of the megaraid driver are you using?
What is the card type please?  What does lspci -vv and lspci -vvn show for it?

>  megaraid: no BIOS enabled.

That's fine, as long as you're not booting from it.

With the above information, we can help.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
