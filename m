From: Sancho Dauskardt <sancho@dauskardt.de>
Subject: Re: /proc/scsi/map
Date: Sun, 16 Jun 2002 00:40:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.0.2.1.2.20020616003031.02a06330@pop.puretec.de>
References: <UTC200206152154.g5FLsCI23053.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D0BBF4B.42E355A6@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>, Andries.Brouwer@cwi.nl
Cc: garloff@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net


>
>In lk 2.5 we are hoping that driverfs will give us an
>"information bridge" between scsi pseudo devices
>and other driver subsystems such as ide, usb and iee1394.
>Mike Sullivan's persistent naming patch (that I mentioned
>in my previous post on this thread) adds driverfs capability
>into the scsi subsystem. Driverfs capability is already
>in the ide and usb subsystems.
Driverfs will hopefully solve the problem, of "oh there's a SCSI device. 
how is it connected ?".

But to date, SCSI doesn't know about the GUID's, right ?
And without this, we won't get a uniform way of creating stable names for 
hot-plugable devices...

- sda

