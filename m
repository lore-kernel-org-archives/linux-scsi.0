From: linux@horizon.com
Subject: What's a good basic SCSI controller these days?
Date: 12 Apr 2002 02:02:01 -0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020412020201.15062.qmail@science.horizon.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux@horizon.com

My AdvanSys ABP940-UW controller recently went tits-up.  The BIOS works, but
neither Linux nor Windows does.  Reading back the microcode always
returns 0x2002, regardless of what was written.

All I have hooked up to it at the moment is a nice Plextor CD-RW, so I'm
not dying, but it is annoying.

It appears that AdvanSys is out of business.  A company named Initio
picked up some of their assets, but not that controller line.

So I need something else.

BusLogic were known for good Linux support, and I have a BT-946C in
service in another machine, but now Mylex only seems to make high-end
RAID controllers.

The Tekram DC3x5 appears to be the current low-end champion, and it has
Linux support, but the driver is still separate from 2.4, and Kurt
Garloff still calls it beta, with some unresolved issues.

Adaptec is old reliable.  And reliably expensive.

Then there are some oddball ones by SIIG that are apparently rebranded
Initio cards.

I'm feeling a bit leery of Initio, since I got burned by AdvanSys and
they're the heirs, but I suppose if they're good enough...


Is there any recommended list for cheap, efficient, well-supported
SCSI cards?

Thanks!
