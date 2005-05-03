From: Andy <genanr@emsphone.com>
Subject: WARNING : kernel 2.6.11.7 (others) kills megaraid 4e/Si dead
Date: Tue, 3 May 2005 10:15:32 -0500
Message-ID: <20050503151532.GA1316@thumper2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thumper2.emsphone.com ([199.67.51.102]:26827 "EHLO
	thumper2.allantgroup.com") by vger.kernel.org with ESMTP
	id S261729AbVECPPx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 May 2005 11:15:53 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

cross posted due to the severity of this issue.

I have killed two Dell 1850 (x86_64) with megaraid 4e/SI servers using
kernel 2.6.11.7.  When the system boots, it looks like it does not see the
megaraid controller (because it never prints anything about it) and hangs
when it tries to mount root.  When rebooted, the system says no firmware
present for embedded raid controller.  I then try to flash it, the flash
program says the firmware is corrupt and flashes the controller.  However,
upon reboot I still get the no firmware present, thus the machine can no
longer boot off the raid.

Andy
