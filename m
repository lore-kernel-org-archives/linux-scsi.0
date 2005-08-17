From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: oops when removing storage device with no actual drive
Date: Wed, 17 Aug 2005 07:24:13 -0500
Message-ID: <1124281453.5038.1.camel@mulgrave>
References: <43023C86.8050705@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:6117 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751111AbVHQMYd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Aug 2005 08:24:33 -0400
In-Reply-To: <43023C86.8050705@gmx.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marko Macek <Marko.Macek@gmx.net>
Cc: linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-08-16 at 21:20 +0200, Marko Macek wrote:
> EIP is at sysfs_hash_and_remove+0x13/0xeb

This is suspiciously similar to the oops when trying to add new class
links in the devices.  Could you try the fix reported there:

http://marc.theaimsgroup.com/?l=linux-scsi&m=112398346008284

And see if it works for you?

Thanks,

James


