From: Lee Revell <rlrevell@joe-job.com>
Subject: aic79xx -> can't  suspend
Date: Thu, 23 Jun 2005 13:51:43 -0400
Message-ID: <1119549104.13259.1.camel@mindpipe>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mustang.oldcity.dca.net ([216.158.38.3]:19404 "HELO
	mustang.oldcity.dca.net") by vger.kernel.org with SMTP
	id S262647AbVFWRvt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2005 13:51:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>

I have a machine with an Adaptec 2940U2W adapter running 2.6.11.  When I
try to go into standby like so:

    echo standby > /sys/power/state

this is what happens:

Stopping tasks:
===============================================================
stopping tasks failed (1 tasks remaining)
Restarting tasks...<6> Strange, ahc_dv_0 not stopped
done 

The machine fails to suspend, and ahc_dv_0 is now wedged, consuming all
available CPU until reboot.

PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  SWAP WCHAN     COMMAND
735 root      39  19     0    0    0 S 99.3  0.0  53:09.97    0 text.lock [ahc_dv_0]

Lee






