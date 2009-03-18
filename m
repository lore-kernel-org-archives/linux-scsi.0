From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: hdparm with USB disk
Date: Wed, 18 Mar 2009 08:44:41 -0400
Message-ID: <49C0ECB9.2030500@interlog.com>
References: <alpine.LSU.2.00.0903181226530.27821@fbirervta.pbzchgretzou.qr>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40091 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbZCRMot (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2009 08:44:49 -0400
In-Reply-To: <alpine.LSU.2.00.0903181226530.27821@fbirervta.pbzchgretzou.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-scsi@vger.kernel.org

Jan Engelhardt wrote:
> Hi,
> 
> 
> so it happens I have to work with one of those shitty "green" devices 
> again that think their power management is smarter than me. 
> Unfortunately, hdparm just does not fly with USB devices, so what is the 
> preferred tool here?
> 
> # hdparm -B 254 /dev/sdb
> 
> /dev/sdb:
>  setting Advanced Power Management level to 0xfe (254)
>  HDIO_DRIVE_CMD failed: Input/output error

A SAT layer that supports the SCSI ATA PASS-THROUGH command
is required in the device. Some USB external drives (often
from major disk manufacturers) now support that.

A version of hdparm that knows about SAT is also required.
 From memory that is from around hdparm version 7.0 onwards.

Doug Gilbert

