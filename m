From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: TCQ depth of aic7xxx
Date: Thu, 17 Aug 2006 08:55:28 +0200
Message-ID: <1155797728.4494.25.camel@laptopd505.fenrus.org>
References: <3a1eedb70608160501l1637a01ai97faadbe6ea5620f@mail.gmail.com>
	 <1155730591.3023.31.camel@laptopd505.fenrus.org>
	 <3a1eedb70608162030q44123f9csc3d51039c969bb8c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:61662 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932066AbWHQGzu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Aug 2006 02:55:50 -0400
In-Reply-To: <3a1eedb70608162030q44123f9csc3d51039c969bb8c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jassduec@gmail.com
Cc: linux-scsi@vger.kernel.org

On Wed, 2006-08-16 at 22:30 -0500, jassduec@gmail.com wrote:
> Thanks for the reply.
> 
> Yeah, I have a raid array connected to the SCSI interface. There are
> two raidgroups in the array using RAID 5. Each raidgroup consists of
> 5-6 disks and one LUN over the entire raidgroup. The LUNs have been
> partitioned at the OS level into different partitions. The storage
> system has a battery protected cache of 16 MB. What range of values of
> TCQ depth would be good enough in such a scenario? I want that the
> SCSI HBA not be the bottleneck and get the maximum out of the storage
> system.

for a setup like this, especially due to the ram, I'd set it as high as
you can, which probably is something like 253 or so.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com

