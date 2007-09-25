From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Patch added to scsi-pending-2.6:  [SCSI] ips: Update version information
Date: Tue, 25 Sep 2007 10:07:48 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01E8B2E1@otce2k301.adaptec.com>
References: <200709231444.l8NEipj5029582@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:41590 "HELO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751416AbXIYOGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 10:06:47 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200709231444.l8NEipj5029582@hera.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org
Cc: James Bottomley <jejb@kernel.org>

ACK

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: James Bottomley [mailto:jejb@kernel.org] 
> Sent: Sunday, September 23, 2007 10:45 AM
> To: AACRAID; Bernhard Walle; James Bottomley
> Subject: Patch added to scsi-pending-2.6: [SCSI] ips: Update 
> version information
> 
> Your commit:
> 
>     [SCSI] ips: Update version information
>     
>     This patch just makes the version number in ips.c and ips.h
consistent. It
>     seems that this has been forgotten in
a60768e2d43eb30a1adb8a119aeac35dc0d03ef6.
>     
>     It also removes code duplication, each number is now only once in
the code to
>     avoid similar errors in the future.
>     
>     Signed-off-by: Bernhard Walle <bwalle@suse.de>
>     Cc: Mark Salyzyn <aacraid@adaptec.com>
>     Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
> 
> has been added to the pending SCSI tree
> You can find it here:
> 
>
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-pending-2.6.git;a=co
mmit;h=7c3f6ca91cd906476274db6b9ecc536eb66fb908
