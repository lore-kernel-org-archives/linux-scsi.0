From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: use_clustering again
Date: Thu, 28 Sep 2006 17:36:56 -0400
Message-ID: <yq1d59fk70n.fsf@sermon.lab.mkp.net>
References: <200609241605.32327.johna@onevista.com>
	<Pine.LNX.4.60.0609272246320.7350@poirot.grange>
	<Pine.LNX.4.64.0609282231030.6979@kai.makisara.local>
	<Pine.LNX.4.60.0609282211560.3268@poirot.grange>
	<451C2795.8040509@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:29885 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S932125AbWI1Vg7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Sep 2006 17:36:59 -0400
In-Reply-To: <451C2795.8040509@cs.wisc.edu> (Mike Christie's message of "Thu, 28 Sep 2006 15:50:45 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

>>>>> "Mike" == Mike Christie <michaelc@cs.wisc.edu> writes:

Mike> If you are just trying to get to 1MB, then instead of enabling
Mike> clustering we could also increase the defaul
Mike> SCSI_MAX_PHYS_SEGMENTS. It is 128 now, but there is a compile
Mike> option to set it it up to 256.

I have essentially been having the same problem doing big direct I/Os
using sg.  I ended up bumping sg_tablesize to 1024 but only because I
knew the controllers used for this application support that many
scatter-gather segments.

As you mention, SG_ALL is 255 and that used to be the max value (quite
useless, just short of 1MB).  In recent kernels it's been clamped to
128 thanks to getting intimate with the block/request layer.

These short lists are quite useless for contemporary tape hardware
that need a block size of 1MB at the minimum and preferably 2MB or
more...

-- 
Martin K. Petersen	Oracle Linux Engineering


