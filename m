From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Mon, 07 Jun 2010 12:20:13 -0400
Message-ID: <yq1zkz6vmpu.fsf@sermon.lab.mkp.net>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	<yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	<20100531144648.GA19068@schmichrtp.mainz.de.ibm.com>
	<yq11vcqlwp8.fsf@sermon.lab.mkp.net>
	<20100602133748.GA11196@schmichrtp.mainz.de.ibm.com>
	<20100602232039.GA8287@dastard> <yq139x3y411.fsf@sermon.lab.mkp.net>
	<20100604023253.GF19651@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100604023253.GF19651@dastard> (Dave Chinner's message of "Fri,
	4 Jun 2010 12:32:53 +1000")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Dave" == Dave Chinner <david@fromorbit.com> writes:

>> Didn't you use to wait_on_page_writeback() in page_mkwrite()?

Dave> The generic implementation of ->page_mkwrite
Dave> (block_page_mkwrite()) which XFS uses has never had a
Dave> wait_on_page_writeback() call in it.  There's no call in the
Dave> generic write paths, either, hence my comment that only direct IO
Dave> on XFS will work.

I guess that wait_on_page_writeback() was something I added when I used
XFS for DIF testing.

-- 
Martin K. Petersen	Oracle Linux Engineering
