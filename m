From: Meelis Roos <mroos@ut.ee>
Subject: Re: qlogicpti driver hangs the machine
Date: Wed, 24 Sep 2008 12:21:02 +0300 (EEST)
Message-ID: <Pine.SOC.4.64.0809241219580.5455@math.ut.ee>
References: <20080923.212513.184633012.davem@davemloft.net>
 <20080924044211.GL27204@parisc-linux.org> <20080923.215302.152506074.davem@davemloft.net>
 <20080924.014553.221132445.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20080924.014553.221132445.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> Unfortunately, the driver works just fine for me, in fact it's
> checking the root filesystem right now :-)

Hmm, it might to do with the disk that I tried with qlogicpti's on both 
systems. It's an externa SUN4.2G disk in unipack enclosure. I don't know 
about its health, only that it shows up in probe-scsi-all PROM command.

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
