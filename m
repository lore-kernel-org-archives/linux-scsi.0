From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: Re[8]: problems with scsi_transport_fc and qla2xxx
Date: Sun, 12 Mar 2006 00:10:14 +0300
Message-ID: <1699632492.20060312001014@netvision.net.il>
References: <1119462161.20060306230951@netvision.net.il>
 <20060306212835.GO6278@andrew-vasquezs-powerbook-g4-15.local>
 <1229893529.20060307000953@netvision.net.il>
 <20060306232831.GS6278@andrew-vasquezs-powerbook-g4-15.local>
 <1219491790.20060307124035@netvision.net.il>
 <20060307172227.GE6275@andrew-vasquezs-powerbook-g4-15.local>
 <1343850424.20060307231141@netvision.net.il>
 <20060308080050.GF9956@andrew-vasquezs-powerbook-g4-15.local>
 <20060308154341.GA1779@andrew-vasquezs-powerbook-g4-15.local>
 <1502511597.20060308213247@netvision.net.il>
 <20060310231344.GB641@andrew-vasquezs-powerbook-g4-15.local>
Reply-To: Maxim Kozover <maximkoz@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxout1.netvision.net.il ([194.90.9.20]:1135 "EHLO
	mxout1.netvision.net.il") by vger.kernel.org with ESMTP
	id S1751280AbWCKWJc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Mar 2006 17:09:32 -0500
In-reply-to: <20060310231344.GB641@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Andrew!
Congratulations! The kernel from scsi-rc-fixes git and your patch are
working.
By the way, could you, please, tell me how I get only scsi patches
from the git repository, cause I got the whole kernel by using
cg-clone http://kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

Now the process looks like following:
Mar 11 23:54:22 multipath kernel: qla2xxx 0000:03:01.0: LOOP DOWN detected (2).
Mar 11 23:54:28 multipath kernel:  rport-4:0-0: blocked FC remote port time out:
 removing target and saving binding
Mar 11 23:54:37 multipath kernel: qla2xxx 0000:03:01.0: LIP reset occured (f7f7).
Mar 11 23:54:37 multipath kernel: qla2xxx 0000:03:01.0: LOOP UP detected (2 Gbps).
Mar 11 23:54:59 multipath kernel:  4:0:0:0: timing out command, waited 22s

And the disks appear.
Could you tell me, please, where this 22sec timeout came from?

Again, congratulations for good work!

Thanks much,

Maxim.

