From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Fri, 06 Jun 2008 12:48:19 -0400
Message-ID: <yq14p86mrvw.fsf@sermon.lab.mkp.net>
References: <patchbomb.1212643369@sermon.lab.mkp.net>
	<20080605062754.GQ2961@webber.adilger.int>
	<yq1od6fml2q.fsf@sermon.lab.mkp.net>
	<20080606140205.GF19246@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080606140205.GF19246@shareable.org> (Jamie Lokier's message of "Fri\, 6 Jun 2008 15\:02\:05 +0100")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Andreas Dilger <adilger@sun.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Jamie" == Jamie Lokier <jamie@shareable.org> writes:

Jamie> Where it is due to specific values being not exactly right -
Jamie> like the subdevice offset (or modulo-offset) in MD because it
Jamie> doesn't represent all subdevices - it would be good for the
Jamie> info to have flags saying which _specific_ values are not
Jamie> exactly right.

You get that traversing the sysfs tree.


Jamie> So that programs can choose their heuristics appropriately.
Jamie> After all, users will use suboptimal layouts, and still want
Jamie> the best performance it can do.

I'd like to keep a clear distinction between normal applications and
programs like mkfs.  I'm targeting the latter.

Given that filesystems can lay out files at will, I/O characteristics
for normal applications is really FIEMAP territory.

-- 
Martin K. Petersen	Oracle Linux Engineering

