From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Thu, 6 Nov 2003 11:33:28 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598CEA@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
content-class: urn:content-classes:message
To: arjanv@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Arjan,

> > No.  We've had this IOWR problem since the inception of 5.x series
> > driver.  Software (SMS 3.0) has been built on top of the this
> > IOCTL
> 
> how about removing most if not all of these ioctls ?  The scsi layer
> has a *generic* "send passthrough" mechanism already for example.
> 

I'm not entirely clear on what you are alluding to here, are you
referring to SCSI_IOCTL_SEND_COMMAND?  There's significantly more
functionality embedded within the IOCTLs than simply sending passthrus
to devices.  Also, all of QLogic's drivers (linux, solaris, windows)
implement to this 'external ioctl' spec, making changes to Linux alone
would difficult.

Regards,
Andrew Vasquez
