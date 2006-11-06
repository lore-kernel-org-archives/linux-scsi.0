From: Jaco van der Schyff <jvds@netgroup.co.za>
Subject: Automatic LUN detectioning not working
Date: Mon, 6 Nov 2006 11:07:02 +0200
Message-ID: <20061106090702.GA8071@npjaco.netgroup.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.netgroup.co.za ([196.25.213.80]:31968 "EHLO
	mail.netgroup.co.za") by vger.kernel.org with ESMTP
	id S1161726AbWKFJHB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Nov 2006 04:07:01 -0500
Received: from [192.168.61.254] (helo=localhost)
	by mail.netgroup.co.za with esmtp (Exim 4.60)
	(envelope-from <jvds@netgroup.co.za>)
	id 1Gh0RW-0006fn-QV
	for linux-scsi@vger.kernel.org; Mon, 06 Nov 2006 11:06:59 +0200
Received: from npjaco by localhost with local (Exim 4.63)
	(envelope-from <jvds@netgroup.co.za>)
	id 1Gh0Ra-0002OJ-EE
	for linux-scsi@vger.kernel.org; Mon, 06 Nov 2006 11:07:02 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I wonder if you guys might be able to help.  Automatic LUN detection
does not seem to be functioning on my kernel despite all my efforts to
persuade it otherwise. (Kernel 2.6.17.6, although I tried newer versions
aswell...)

CONFIG_SCSI_MULTI_LUN=y is set in my kernel config, and I am passing
max_luns=12 as kernel parameter.  The scsi system is _not_ compiled as a
module, and my HBA is in Adaptec 3930A-R, (aic79xx)

Once the system has booted, I can force it to detect all luns with:

echo "0 0 1" > /sys/class/scsi_host/host[x]/scan
echo "0 0 2" > /sys/class/scsi_host/host[x]/scan
echo "0 0 3" > /sys/class/scsi_host/host[x]/scan

I have a hardware RAID array connected to the HBA which maps 4 x 1TB
slices to LUNS[0-3].

Like I said the kernel is only interested in LUN0 for some reason...

Any way I can ask my kernel to detect all LUNs at startup?

Kind regards,

- Jaco van der Schyff

