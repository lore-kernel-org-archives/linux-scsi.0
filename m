From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: SCSI woes (followup)
Date: Wed, 25 Sep 2002 00:33:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020925003335.D9952@flint.arm.linux.org.uk>
References: <20020924233941.A9952@flint.arm.linux.org.uk> <200209242314.g8ONEHU02783@localhost.localdomain> <20020924232630.GD1330@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flint.arm.linux.org.uk ([3ffe:8260:2002:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.04)
	id 17tzBQ-000151-00
	for linux-scsi@vger.kernel.org; Wed, 25 Sep 2002 00:33:36 +0100
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.04)
	id 17tzBP-00035i-00
	for linux-scsi@vger.kernel.org; Wed, 25 Sep 2002 00:33:35 +0100
Content-Disposition: inline
In-Reply-To: <20020924232630.GD1330@beaverton.ibm.com>; from andmike@us.ibm.com on Tue, Sep 24, 2002 at 04:26:30PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Sep 24, 2002 at 04:26:30PM -0700, Mike Anderson wrote:
> James Bottomley [James.Bottomley@SteelEye.com] wrote:
> > send it off to Marcelo and I'll try to up-port to 2.5
> 
> If you want me to I can add it to a patch bundle I already have that
> includes ports of Russell's previous changes that apply on top of my
> 2.5 scsi_error cleanup patch.

Thanks Mike; I should really be looking at 2.5 kernel stuff for the ARM
CPU at the moment (like getting a new release out.)

There is a trivial but required fix that I should backport from 2.5 to
2.4; that's the one that limits the number of command retries in
scsi_error.c.  I'm not sure if Doug Ledford picked that one up though.
Doug?

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

