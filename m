From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: scsi_set_medium_removal timeout issue
Date: Mon, 12 Nov 2018 10:33:04 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1811121031180.7773-100000@netrider.rowland.org>
References: <678F3D1BB717D949B966B68EAEB446ED1F1B7CD4@dggemm526-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <678F3D1BB717D949B966B68EAEB446ED1F1B7CD4@dggemm526-mbx.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Zengtao (B)" <prime.zeng@hisilicon.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net" <usb-storage@lists.one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org

On Mon, 12 Nov 2018, Zengtao (B) wrote:

> >> >Something is wrong here.  Before sending PREVENT-ALLOW MEDIUM
> >> >REMOVAL, the host should issue SYNCHRONIZE CACHE.  This will force
> >> >fsg_lun_fsync_sub to run, and the host should allow a long timeout
> >> >for this command.  Then when PREVENT-ALLOW MEDIUM REMOVAL
> >is sent,
> >> >nothing will need to be flushed.
> >> >
> >>
> >> Definitely, I haven't seen the SYNCHRONIZE CACHE from the host, it
> >> directly issued the PREVENT-ALLOW MEDIUM REMOVAL, so maybe
> >something
> >> wrong with the scsi layer or something wrong with the mass storage
> >class driver?
> >
> >Or it could be something else.  Can you please post the dmesg log from
> >the host, showing what happens when the device is first plugged in?
> >
> 
> I have enabled the SCSI log for the host, please refer to the attachment.

The log you attached was incomplete -- it was missing some commands 
from the beginning.  In any case, it wasn't what I wanted.  I asked
you to post the dmesg log, not the SCSI log.

Alan Stern
