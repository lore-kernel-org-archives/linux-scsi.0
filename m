From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Kernel crashing on eject SD card
Date: Sun, 12 Feb 2012 22:20:27 +0100
Message-ID: <20120212222027.71651e8b@stein>
References: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca>
	<20120212220836.6aa7fa4d@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120212220836.6aa7fa4d@stein>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Naveen Goswamy <naveen.goswamy@polymtl.ca>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Feb 12 Stefan Richter wrote:
> Modules linked in: [...] vboxnetadp(O) vboxnetflt(O) vboxdrv(O) [...]

Oh, could you try without virtualbox?

The debian bug report hints that kernel 3.2 /without virtualbox drivers/
seems to behave itself.
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=649735
-- 
Stefan Richter
-=====-===-- --=- -==--
http://arcgraph.de/sr/
