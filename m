From: Jens Axboe <axboe@suse.de>
Subject: Re: buffer-list destroyed message
Date: Sat, 26 Apr 2003 11:25:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030426092552.GZ1012@suse.de>
References: <1051291883.1172.358.camel@tubarao>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:62909 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264635AbTDZJNl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 05:13:41 -0400
Content-Disposition: inline
In-Reply-To: <1051291883.1172.358.camel@tubarao>
List-Id: linux-scsi@vger.kernel.org
To: Thayne Harbaugh <tharbaugh@lnxi.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Apr 25 2003, Thayne Harbaugh wrote:
> I have a system that spits out the following error message:
> 
> scsi_end_request: buffer-list destroyed
> 
> It appears to come from drivers/scsi/scsi_lib.c: __scsi_end_request()
> 
> I can see that the code detects a mis-match in the number of sectors. 
> I'm wondering if anyone can enlighten me on how serious this problem is
> (the machine appears to work fine), what might be causing the problem,
> and how I might fix things.

The problem is very serious and is usually accompanied by data
corruption. So I suggest you check your filesystems! It depends on the
driver, though. I can say with absolute certainty that a healthy system
should _never_ see those messages.

> I searched the archives and only found one mail that seemed relevant:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=93303946423398&w=2
> 
> The comment for the MegaRAID refers to SMP and that the system appears
> to continue to function with no problems - two symptoms of the machine I
> have.  Yep, not a lot of information.

So almost certainly a megaraid bug. Is is easily reproduceable? Does it
occur with a UP kernel?

-- 
Jens Axboe

