From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: SCSI passthrough ioctl calls vs. sd/sg devices
Date: Sat, 24 Apr 2004 09:58:26 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0404240950330.7758@kai.makisara.local>
References: <519672568F040C41B6FAC21ADF51B18FEFBE@mailnode1.commstor.crossroads.com>
 <4089E7B2.5060803@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:16893 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S262009AbUDXG6c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Apr 2004 02:58:32 -0400
In-Reply-To: <4089E7B2.5060803@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Lee Xing <lxing@Crossroads.com>, linux-scsi@vger.kernel.org

On Sat, 24 Apr 2004, Douglas Gilbert wrote:

...
> In the lk 2.6 series the SG_IO ioctl is available for block
> devices which include SCSI disks and ATAPI dvd/cd drives.
> The SG_IO ioctl is currently not available for SCSI char
> device drivers (e.g. st and osst) other than sg itself.

SG_IO is available for st in current 2.6 (Patrick Mansfield added a few 
lines of code to st.c). Similar changes could be probably done to osst.

-- 
Kai
