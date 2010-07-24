From: Dave Chinner <david@fromorbit.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Sat, 24 Jul 2010 11:03:59 +1000
Message-ID: <20100724010358.GO32635@dastard>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
 <1275318102.2823.47.camel@mulgrave.site>
 <4C03D5FD.3000202@panasas.com>
 <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
 <1275398876.21962.6.camel@mulgrave.site>
 <4C078FE2.9000804@vlnb.net>
 <AANLkTinnrsFZ=nkX4QpG2eKOk05uNe5HpV-pP3kd7OF=@mail.gmail.com>
 <4C49EA91.3060908@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:54297 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756489Ab0GXBEK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jul 2010 21:04:10 -0400
Content-Disposition: inline
In-Reply-To: <4C49EA91.3060908@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Gennadiy Nerubayev <parakie@gmail.com>, James Bottomley <James.Bottomley@suse.de>, Christof Schmitt <christof.schmitt@de.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On Fri, Jul 23, 2010 at 11:16:33PM +0400, Vladislav Bolkhovitin wrote:
> It would be great if you prove or disprove our suspicions that Linux
> can produce several write requests for the same blocks
> simultaneously. To be sure we need:

Just use direct IO. Case in point is the concurrent sub-block
AIO-DIO data corruption we're chasing on XFS and ext4 at the moment
where we have two concurrent unaligned write IOs to the same
filesystem block:

http://oss.sgi.com/archives/xfs/2010-07/msg00278.html

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
