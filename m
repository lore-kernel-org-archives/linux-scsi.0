From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 01 Jun 2010 09:16:35 -0400
Message-ID: <yq11vcqlwp8.fsf@sermon.lab.mkp.net>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	<yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	<20100531144648.GA19068@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100531144648.GA19068@schmichrtp.mainz.de.ibm.com> (Christof
	Schmitt's message of "Mon, 31 May 2010 16:46:49 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:

>> Yep, known bug.  Page writeback locking is messed up for buffer_head
>> users.  The extNfs folks volunteered to look into this a while back
>> but I don't think they have found the time yet.

Christof> Thanks for the info. This means that this bug appears with all
Christof> filesystems?

XFS and btrfs should be fine.

-- 
Martin K. Petersen	Oracle Linux Engineering
