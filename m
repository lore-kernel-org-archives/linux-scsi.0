From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: [PATCH] usb: uas: fix usb subsystem hang after power off hub
 port
Date: Mon, 8 Apr 2019 21:21:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1904082118490.1490-100000@netrider.rowland.org>
References: <AE5419EAB4965843B3C0C1FE29F1FFE5892A0D@JPYOKXMS103.jp.sony.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AE5419EAB4965843B3C0C1FE29F1FFE5892A0D@JPYOKXMS103.jp.sony.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kento.A.Kobayashi@sony.com
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, oneukum@suse.com, gregkh@linuxfoundation.org, usb-storage@lists.one-eyed-alien.net, Jacky.Cao@sony.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 9 Apr 2019 Kento.A.Kobayashi@sony.com wrote:

> Hi,
> 
> >So it looks as though the SCSI subsystem doesn't like to have a reset handler call scsi_remove_host.  Commands dispatched by the removal routines are forced to wait for the reset recovery to finish, which won't happen until those commands have been completed.
> 
> You mean reset handeler should not call scsi_remove_host, right?
> But actually, scsi_remove_host is called from reset handler in this case.
> 
> >Is this a bug in the SCSI core? 
> No, I think this is a bug in uas driver.

Actually I was asking James and Martin, not you.

In any case, even assuming the cause of the problem is on the USB side, 
it's not clear whether the bug is in uas or in usbcore.

Alan Stern
