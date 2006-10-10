From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid driver incomplete regarding info + logging
Date: Tue, 10 Oct 2006 11:40:44 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F02D8131A@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:36772 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1750726AbWJJPkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2006 11:40:45 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Metathronius Galabant <m.galabant@googlemail.com>, linux-scsi@vger.kernel.org

The aeventd daemon looks after most of this information. It is a
simplified, public domain, internationalized event daemon and thus
resides in user space. Contact me privately to acquire the rpm.

There is not enough space to waste in the kernel to add such features,
and there is a dynamic and complicated relationship between the full
fledged native and proprietary management applications shipped by
Adaptec and the firmware to deal with such information in a driver. I
suggest you use the Adaptec Storage Management software, runs on most,
if not all, variants of Linux.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of 
> Metathronius Galabant
> Sent: Tuesday, October 10, 2006 8:00 AM
> To: linux-scsi@vger.kernel.org
> Subject: aacraid driver incomplete regarding info + logging
> 
> 
> Dear all,
> 
> when using the aacraid driver I found out that the driver is 
> grossly incomplete.
> 
> 1) there is no /proc/scsi/aacraid/... interface about the 
> volume/adapter status
> 2) there is no printk() when a raid fails, is rebuilding, has finished
> rebuilding etc.
> 
> Are there any patches that go into this direction?
> Else I *might* find time to contribute some code if I can get 
> some guidance.
> 
> Cheers,
> M
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
