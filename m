From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: scsi_set_medium_removal timeout issue
Date: Wed, 14 Nov 2018 10:35:28 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1811141027420.1637-100000@iolanthe.rowland.org>
References: <678F3D1BB717D949B966B68EAEB446ED1F1BC495@dggemm526-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <678F3D1BB717D949B966B68EAEB446ED1F1BC495@dggemm526-mbx.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Petersen <martin.petersen@oracle.com>, "Zengtao (B)" <prime.zeng@hisilicon.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "usb-storage@lists.one-eyed-alien.net" <usb-storage@lists.one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org

On Wed, 14 Nov 2018, Zengtao (B) wrote:

> I just enabled the scsi log in the middle of the umount operation, otherwise I can't
> reproduce the issue when the scsi log is enabled.
> 
> >from the beginning.  In any case, it wasn't what I wanted.  I asked you to
> >post the dmesg log, not the SCSI log.
> 
> Please refer to the new attachment for dmesg log.

Heh, yes, I see now.

Martin, shouldn't sd_release() call sd_sync_cache() in the same way
that sd_shutdown() does, before it calls scsi_set_medium_removal()?

Alan Stern
