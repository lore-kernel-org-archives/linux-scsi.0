From: James.Smart@Emulex.Com
Subject: RE: [PATCH] add transport class symlink to device object
Date: Thu, 18 Aug 2005 07:31:54 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F4423@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50634 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932199AbVHRLce convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2005 07:32:34 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rmk+lkml@arm.linux.org.uk, greg@kroah.com
Cc: matthew@wil.cx, akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk

> They are class devices called ttyS0, ttyS1, ttyS2 so you can say
> they're uniquely named.
> 
> The problem is that Matthew wants to add a symlink from the device
> device to the class device to complement the class device to device
> symlink, since we end up with multiple symlinks in the devices subdir
> all called the same.
> 
> This causes serial a problem because we have multiple class devices
> per device.

Missing some key words IMHO:

"This causes serial a problem because we have multiple class devices
(and each are of the *same* class) per device"

-- james s
