From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: how to change sector size on fibrechannel drives
Date: Fri, 14 Jun 2002 08:26:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFF900310E.955AB070-ON87256BD8.0054565B@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: David Nedved <dnedved@nuvox.net>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org


>it looks like
>the scu utility itself that has a problem with targets over 15, not just
>the kernel or driver or something.

Yes, probably.  The last time I tried to use Scu (a year ago), I found it
was limited to 15 Linux SCSI slots and had some kind of dependency on the
way my /dev/sgX special files were defined as well.  I couldn't use it for
fibre channel.  I believe I got a combination of refusing to admit the
device exists and segmentation fault.  I did report the problem to the
author.




