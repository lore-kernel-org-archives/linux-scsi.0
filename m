From: Thomas Meller <thomas.meller@gmx.net>
Subject: finding out about QLogic features
Date: Mon, 23 Aug 2004 13:10:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4129D08C.CF43CF96@gmx.net>
Reply-To: thomas.meller@gmx.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sbbmail1.sbb.ch ([193.192.251.19]:39113 "EHLO sbbmail1.sbb.ch")
	by vger.kernel.org with ESMTP id S263640AbUHWLLI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 07:11:08 -0400
Received: from intmail1.sbb.ch (intmail1.sbb.ch [10.104.27.189])
	by sbbmail1.sbb.ch (Switch-3.1.6/Switch-3.1.0) with ESMTP id i7NBB1TP024957
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2004 13:11:01 +0200
Received: from gmx.net (i34390.sbb.ch [147.78.17.245])
	by intmail1.sbb.ch (Switch-3.1.6/Switch-3.1.6) with ESMTP id i7NBAx0R017133
	for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2004 13:11:00 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

My colleagues are going to hang me if my system produces further path failovers.

I use a QLogic 2312-based HBA (FastT FC2-133) in failover mode on a LinuX HA-cluster.

Everything works fine, but the driver causes several failovers per day without an urgent
reason.

We're using a FastT 700 via McData fabric switches.

Driver version 6.06-fo, Firmware 1.25, Kernel 2.4.18.

Maybe I need to tune the driver's parameters to extend some timeouts. Maybe it's as simple
as an upgrade.
I found out that a FastT requires more retries than are set by default.
QLogic support has given me some hints what to cause the scsi subsystem to do.

In short: I have to set a bigger retry count when a device proclaims a not-ready condition.

>From my experience it is best to understand first how it works before setting weird
parameters.
Especially due to the use within a failover cluster it could cause timing problems.

Are there any docs around to make a non-programmer understand the HBA-sd_mod interaction
technique and it's implications?

Is this the right mailing list for me?

Thanks in advance

-- 
Thomas Meller
mailto: thomas.meller@t-systems.ch
mailto: thomas.meller@gmx.net
----
...Our continuing mission: To seek out knowledge of C, to explore strange
UNIX commands, and to boldly code where no man page has ever been seen
