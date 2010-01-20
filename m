From: "Jayamohan Kalickal" <jayamohank@serverengines.com>
Subject: Re: be2iscsi: Bug Fixes Needed
Date: Wed, 20 Jan 2010 10:35:26 -0800
Message-ID: <20100120183526.a36d67d3@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail192.messagelabs.com ([216.82.241.243]:49845 "EHLO
	mail192.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0ATSfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2010 13:35:30 -0500
In-Reply-To: 1263753014.2802.1.camel@mulgrave.site
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

James,

   
          This can wait until the next merge window,so, can go to scsi-misc tree.

Thanks
Jay
  _____  
From: James Bottomley [mailto:James.Bottomley@suse.de]
To: Jayamohan Kalickal [mailto:jayamohank@serverengines.com]
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Sent: Sun, 17 Jan 2010 10:30:14 -0800
Subject: Re: be2iscsi: Bug Fixes Needed

On Thu, 2010-01-07 at 01:49 +0530, Jayamohan Kallickal wrote:
> Hi James
> 
> 	These patches contains some bug fixes that are important for
> the driver.

This phraseology usually means apply to the linus kernel now.

> These patches are created using the latest scsi-misc tree and after
> applying the following patches sent earlier
> 
> http://www.spinics.net/lists/linux-scsi/msg41363.html
> http://www.spinics.net/lists/linux-scsi/msg41364.html

However, these are an enhancement stream for the kernel.

So I'm assuming these aren't essential bug fixes, but can wait until the
next merge window?  If not, they need to be made against current
upstream (because they won't apply without the updates patches).

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

