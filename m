From: "Mukker, Atul" <atulm@lsil.com>
Subject: RE: What's a good basic SCSI controller these days?
Date: Fri, 12 Apr 2002 07:54:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57A8B205@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mhbs.lsil.com (mhbs [147.145.31.100])
	by mail2.lsil.com (8.9.3+Sun/8.9.1) with ESMTP id EAA13980
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2002 04:54:50 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: "'linux@horizon.com'" <linux@horizon.com>, linux-scsi@vger.kernel.org

Why don't you go to http://megaraid.lsilogic.com and see if some of the
controllers match your criteria.

-Atul Mukker




-----Original Message-----
From: linux@horizon.com [mailto:linux@horizon.com]
Sent: Thursday, April 11, 2002 10:02 PM
To: linux-scsi@vger.kernel.org
Cc: linux@horizon.com
Subject: What's a good basic SCSI controller these days?


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
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
