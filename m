From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH][RFC] ST Tape assignement
Date: Wed, 24 Jul 2002 20:22:42 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0207242016020.3585-100000@kai.makisara.local>
References: <Pine.LNX.4.21.0207241623140.990-100000@ftp.philosys.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.21.0207241623140.990-100000@ftp.philosys.de>
List-Id: linux-scsi@vger.kernel.org
To: Robert Sertic <robert@philosys.de>
Cc: linux-scsi@vger.kernel.org, Robert.Sertic@gmx.net

On Wed, 24 Jul 2002, Robert Sertic wrote:

>
>
>
> Hi Everybody,
>
> i rewrote my patch so that is applyable to a
> 2.5.27 Kernel. Do you remember???
>
> With this patch you can make an assingement between
> a certain Tape and a device file, so for example
> Tape on ScsiHost 1 Channel 0 ID 5 Lun0 should be
> st31.
>
This problem is better solved outside the kernel. What you need is a
program or script that makes links to the actual devices when they are
found. The program/script should examine the new device and based on the
result it then creates the link with the desired name pointing to the
device. One example of this kind of approach is called scsidev.

	Kai


