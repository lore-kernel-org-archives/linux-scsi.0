From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] merge sd.h into sd.c and some cleanup
Date: Sun, 27 Oct 2002 08:25:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210271425.g9REPTn10749@localhost.localdomain>
References: <dougg@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA31374
	for <linux-scsi@vger.kernel.org>; Sun, 27 Oct 2002 06:25:33 -0800
In-Reply-To: Message from Douglas Gilbert <dougg@torque.net>
   of "Sun, 27 Oct 2002 22:22:03 +1100." <3DBBCC5B.50708@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

dougg@torque.net said:
> The header file "sd.h" is included in quite a few lower level drivers
> in lk 2.5.44 (at least 55) and perhaps in a couple of other
> subsystems. The reason it is included is for the "biosparam" call in
> the API of lower level drivers. Whether it is still used or useful,
> I'm not sure. [It does seem quite unreasonable that lower level
> drivers need to include an upper level header.]

There was a previous patch that cleaned all that up.  I'm just completing 
testing on this before putting it up.

> You can drop my credit line (shown above) from sd.c . Perhaps James
> could make a "credits" file for everyone who has helped in the 2.5
> scsi rework. 

Credits are a double edged sword (If you look, you'll find there's very little 
of the SCSI subsystem I actually admit to).  I've just been adding them if 
people included them in their patches.  Some do, some don't.  If you want 
yours dropped, send me a patch that drops it.

James


