From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: SCSI woes (followup)
Date: Wed, 25 Sep 2002 09:45:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020925094551.B24532@flint.arm.linux.org.uk>
References: <20020924233941.A9952@flint.arm.linux.org.uk> <200209242314.g8ONEHU02783@localhost.localdomain> <20020924232630.GD1330@beaverton.ibm.com> <20020925003335.D9952@flint.arm.linux.org.uk> <20020925004737.GC12650@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flint.arm.linux.org.uk ([3ffe:8260:2002:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.04)
	id 17u7ns-00032H-00
	for linux-scsi@vger.kernel.org; Wed, 25 Sep 2002 09:45:52 +0100
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.04)
	id 17u7nr-0006Uu-00
	for linux-scsi@vger.kernel.org; Wed, 25 Sep 2002 09:45:51 +0100
Content-Disposition: inline
In-Reply-To: <20020925004737.GC12650@beaverton.ibm.com>; from andmike@us.ibm.com on Tue, Sep 24, 2002 at 05:47:38PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Sep 24, 2002 at 05:47:38PM -0700, Mike Anderson wrote:
> I will try to post my update tomorrow, but it will not mean much to 2.4
> as it is on top of the 2.5 cleanup which is very different from 2.4.

Nevertheless, bounding those retries in 2.4 is a must for stability.
Loops that could become infinite one day almost certainly will at some
point.  I think the SCSI subsystem has proven this point in the past. 8/

I've also spotted a few other places that could do with my "restore
Scsi_Cmnd to pristine state after error handling commands have
completed" cleanup in scsi_error.c to ensure that we restore everything
necessary.

I'm putting that at low priority at the moment though.

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

