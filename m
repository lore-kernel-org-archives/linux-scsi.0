From: Daryl Zero <daryl0@nwlink.com>
Subject: Re: sym53c8xx message d sent on bad reselection
Date: Sat, 17 Aug 2002 16:42:45 -0700 (Pacific Daylight Time)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.WNT.4.44.0208171623410.-336279@dbradfor.nwlink.com>
References: <Pine.WNT.4.44.0208171558120.-336279@dbradfor.nwlink.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from MERCURY (ip48.usw4.rb1.pdx.nwlink.com [207.202.183.48])
	by smtp001.nwlink.com (8.12.2/8.12.2) with ESMTP id g7HNgtHW028567
	for <linux-scsi@vger.kernel.org>; Sat, 17 Aug 2002 16:42:55 -0700
In-Reply-To: <Pine.WNT.4.44.0208171558120.-336279@dbradfor.nwlink.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sat, 17 Aug 2002, Daryl Zero wrote:

> The problem I'm having is that now it seems that if I start to copy or
> write things to /disk2, it will work for awhile but then hang, and the
> following message appears on the console:

I also should mention that this "message d sent on bad reselection" error
did NOT occur when I did an SSH file transfer of about 200MB of tar files
over 10Mbit/sec ethernet to that same disk!

Also, on bootup, I get the following messages:

> kmod: failed to exec /sbin/modprobe -s -k scsi_hostadapter, errno = 2

then later,

> modprobe: modprobe: Can't locate module block-major-30

I've no idea what these mean?

Dave


