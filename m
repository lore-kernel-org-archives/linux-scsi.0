From: "Roeland Th. Jansen" <scsi@grobbebol.xs4all.nl>
Subject: BT930 + old scsi disk
Date: Fri, 26 Apr 2002 12:56:55 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020426125655.A1961@grobbebol.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

hi *


I have a BT930 controller; works fine for all scsi disks I have ..
except one..


there is one disk that for the second time has killed the system.


First time I was not at the system when it happened. This time I was.

I heard the following sound (yep, technical ahum) :

click
downspin....
click
upspin......

it was maybe only 3 seconds. but the system froze completely; numlock
leds etc were ok, but magic sysrq didn't work (??)

also, no way I could remotely log onto the system anymore.

At this point, as it's a datadisk, I have taken it off the scsi bus to
prevent further bad things to happen.

unfortunately, there was nothing regarding the scsi controller or disk
in the log.


any ideas what I could do to help preventing this ? (seems somewhere a
bug in the kernel/bt930 ?)



Roeland

