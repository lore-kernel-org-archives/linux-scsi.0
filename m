From: Willem Riede <osst@riede.org>
Subject: Re: SCSI passthrough ioctl calls vs. sd/sg devices
Date: Sat, 24 Apr 2004 08:42:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040424124205.GW13443@serve.riede.org>
References: <519672568F040C41B6FAC21ADF51B18FEFBE@mailnode1.commstor.crossroads.com> <4089E7B2.5060803@torque.net> <Pine.LNX.4.58.0404240950330.7758@kai.makisara.local>
Reply-To: osst@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc13.comcast.net ([204.127.198.39]:8365 "EHLO
	rwcrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S262217AbUDXMmJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Apr 2004 08:42:09 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0404240950330.7758@kai.makisara.local> (from Kai.Makisara@kolumbus.fi on Sat, Apr 24, 2004 at 02:58:26 -0400)
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Douglas Gilbert <dougg@torque.net>, Lee Xing <lxing@Crossroads.com>, linux-scsi@vger.kernel.org

On 2004.04.24 02:58, Kai Makisara wrote:
> On Sat, 24 Apr 2004, Douglas Gilbert wrote:
> 
> ...
> > In the lk 2.6 series the SG_IO ioctl is available for block
> > devices which include SCSI disks and ATAPI dvd/cd drives.
> > The SG_IO ioctl is currently not available for SCSI char
> > device drivers (e.g. st and osst) other than sg itself.
> 
> SG_IO is available for st in current 2.6 (Patrick Mansfield added a few 
> lines of code to st.c). Similar changes could be probably done to osst.

I'll be happy to do that (make the equivalent change to osst) if that's 
the best way to complete the SG_IO support.

Regards, Willem Riede.
