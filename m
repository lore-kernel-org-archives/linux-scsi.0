From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: How to find which (physical) SCSI HBA corresponds to which
	ho	st n umber?
Date: Fri, 01 Apr 2005 15:07:02 -0600
Message-ID: <1112389623.5776.34.camel@mulgrave>
References: <OF48E31788.A91E33AF-ON88256FD6.00605364-88256FD6.00619462@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:21430 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262909AbVDAVHP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2005 16:07:15 -0500
In-Reply-To: <OF48E31788.A91E33AF-ON88256FD6.00605364-88256FD6.00619462@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: "Rajat Jain, Noida" <rajatj@noida.hcltech.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-04-01 at 09:47 -0800, Bryan Henderson wrote:
> If you and Linux could identify the host in common terms, you wouldn't 
> have to do this.  But the question is open as to in what terms you 
> personally identify the host to which you attached the device.  Is it the 
> controller to the west?  The red one?  The new one?  The one with serial 
> number 8436547?  The one at PCI address X:Y:Z?  The one that has your disk 
> drives on it?

I'm not very good on 2.4, but I believe it has a SCSI_IOCTL_GET_PCI.
However, if you're ever planning on moving to 2.6 it might not be such a
good choice since I believe that ioctl now gives the information in a
different format (but obviously, for 2.6, you'd use sysfs anyway and not
bother with ioctls).

James


