From: Ramya Desai <ramya.desai@gmail.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 20:17:02 +0530
Message-ID: <3e7aae31002250647o2f7c380bwcc70fe4d19161681@mail.gmail.com>
References: <3e7aae31002240507r5d5c4c2bj8e653a3d65fa6709@mail.gmail.com>
	 <Pine.LNX.4.44L0.1002241123220.2436-100000@iolanthe.rowland.org>
	 <20100224190753.GF1025@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f172.google.com ([209.85.221.172]:45373 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770Ab0BYOrF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 09:47:05 -0500
In-Reply-To: <20100224190753.GF1025@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Thu, Feb 25, 2010 at 12:37 AM, Jens Axboe <jens.axboe@oracle.com> wr=
ote:

>> At this point everything was set up correctly. =A0I don't know why t=
he
>> transfer lengths are still 512 KB. =A0Maybe someone else has an idea=
=2E
>
> What is the test case issuing the IO? Depending on the device, it may
> hit other restrictions aside from just maximum transfer length.

Dear Jens,

We are just copying the data from PC to usb-storage device (drag and
drop), host to device.

Please let me know, if you need any additional information.

Thansk and Regards,
RD.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
