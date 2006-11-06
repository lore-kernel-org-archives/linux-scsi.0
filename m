From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Automatic LUN detectioning not working
Date: Mon, 06 Nov 2006 10:58:43 +0100
Message-ID: <1162807123.3160.182.camel@laptopd505.fenrus.org>
References: <20061106090702.GA8071@npjaco.netgroup.co.za>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:727 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1423696AbWKFJ6r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Nov 2006 04:58:47 -0500
In-Reply-To: <20061106090702.GA8071@npjaco.netgroup.co.za>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaco van der Schyff <jvds@netgroup.co.za>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-11-06 at 11:07 +0200, Jaco van der Schyff wrote:
> Hi,
> 
> I wonder if you guys might be able to help.  Automatic LUN detection
> does not seem to be functioning on my kernel despite all my efforts to
> persuade it otherwise. (Kernel 2.6.17.6, although I tried newer versions
> aswell...)
> 
> CONFIG_SCSI_MULTI_LUN=y is set in my kernel config, and I am passing
> max_luns=12 as kernel parameter.  The scsi system is _not_ compiled as a
> module, and my HBA is in Adaptec 3930A-R, (aic79xx)
> 
> Once the system has booted, I can force it to detect all luns with:
> 
> echo "0 0 1" > /sys/class/scsi_host/host[x]/scan
> echo "0 0 2" > /sys/class/scsi_host/host[x]/scan
> echo "0 0 3" > /sys/class/scsi_host/host[x]/scan
> 
> I have a hardware RAID array connected to the HBA which maps 4 x 1TB
> slices to LUNS[0-3].
> 
> Like I said the kernel is only interested in LUN0 for some reason...
> 
> Any way I can ask my kernel to detect all LUNs at startup?

Hi,

what probably is needed is to teach the kernel about your array and to
make the kernel either scan all luns or ask the device which luns it
has.
Can you post the /proc/scsi/scsi entry for your array ? (only for the
LUN0 is enough); that information is going to be needed to make a
special entry for your array with either of the two behaviors..

Greetings,
  Arjan van de Ven
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

