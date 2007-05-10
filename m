From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: HDIO_DRIVE_CMD and hdparm
Date: Thu, 10 May 2007 13:51:53 +0100
Message-ID: <20070510135153.5f6d62f8@the-village.bc.nu>
References: <Pine.LNX.4.62.0705101327170.759@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0705101327170.759@pademelon.sonytel.be>
Sender: linux-ide-owner@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>   - SCSI doesn't handle HDIO_DRIVE_CMD(null), and returns EINVAL
>     => fine for hdparm
>   - If a block device doesn't support the ioctl, blkdev_driver_ioctl() returns
>     ENOTTY
>     => hdparm error message

Those are both correct
	-ENOTTY 		I don't know this ioctl
	-EINVAL			I know this ioctl, usage wrong
	0			Hey it worked

	ENOIOCTLCMD		Internal (not user exposed)
				for fallthrough

	ENOSYS			CD-ROM being weird.

