From: "Eff Norwood" <enorwood@effrem.com>
Subject: RE: A modern RAID solution?
Date: Sun, 27 Oct 2002 09:29:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <CFEAJJEGMGECBCJFLGDBIEINCGAA.enorwood@effrem.com>
References: <20021027153048.GA5642@angle.setup.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021027153048.GA5642@angle.setup.org>
List-Id: linux-scsi@vger.kernel.org
To: Alexy Khrabrov <braver@pobox.com>, linux-scsi@vger.kernel.org

> I heard an opinion that software RAID on Linux with SCSI is
> "almost" as good as a hardware controller.  What is the experience
> here?  Also, since I'm running LVM throughout, including the root
> partition, does RAID coexist well with LVM?

In my experience, software RAID is very flexible and good at the expense of
a lot of interrupts and some (5-15%) processor overhead depending on the
RAID level you choose. Hardware RAID is good at the expense of $ and doesn't
use as much processor overhead as software RAID. Ultimately, I chose
software RAID because it was vastly more flexible for me. I also abandoned
LVM and now use an IBM open source RAID/Volume manager called EVMS.
http://evms.sourceforge.net. The other thing about software RAID is that if
you move your drives to a new system, they'd still likely work. If you need
to move a hardware RAID card to a new system and it won't work in that
system, you might be out of luck.

Eff Norwood


