From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: ugliness with USB hot-unplug
Date: 16 Nov 2004 09:17:11 -0600
Message-ID: <1100618237.2279.11.camel@mulgrave>
References: <20041115212858.29d3c73d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:57519 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262010AbUKPPRg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 10:17:36 -0500
In-Reply-To: <20041115212858.29d3c73d.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-11-15 at 23:28, Andrew Morton wrote:
> So I made the mistake of forgetting to unmount the fat filesytem before
> unplugging the USB cable from the digital camera.  I then tried to unmount
> the old mountpoint.  khubd is sitting there chewing 100% CPU and I have a
> reboot in my near future.

Yes, this is a known issue.  Mike Christie provided the fix, and I was
just about to put it in the rc-fixes tree last night when BK threw a
wobbly and corrupted its ChangeSet in my local tree.  I'm just going
back now and trying to work out which patches I need to rescue from my
email and put into a rebuilt tree.

James


