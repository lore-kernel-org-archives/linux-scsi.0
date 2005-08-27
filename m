From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] minimal SAS transport class
Date: Sat, 27 Aug 2005 09:35:48 +0200
Message-ID: <431017D4.9040305@s5r6.in-berlin.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com> <430B5CDB.9070204@s5r6.in-berlin.de> <430BB91F.7000406@vger.kernel.org> <20050824091230.GB26447@infradead.org> <430F398A.30200@adaptec.com> <430F6C56.1090801@pobox.com> <430F710E.7020206@adaptec.com> <430FC7B2.7080700@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45239 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1030330AbVH0HgI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Aug 2005 03:36:08 -0400
In-Reply-To: <430FC7B2.7080700@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Garzik <jgarzik@pobox.com>, Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@infradead.org>

Jeff Garzik wrote:
> An in-kernel C pointer, to a SCSI target device, is 
> not sufficient in all cases to address a target.  This plays out most 
> often in userland interfaces such as ioctls.

The C pointer is all the interface between core and low-level needs.

All other means of addressing (IDs, labels, ... of which HCIL is only 
one kind) are only meaningful to userspace. The labels may be 
_generated_ at any level (low, core, high) depending on their context, 
but they are _used_ only in userspace->kernel interfaces.

The core provides the map of devices<->labels.
-- 
Stefan Richter
-=====-=-=-= =--- ==-==
http://arcgraph.de/sr/
