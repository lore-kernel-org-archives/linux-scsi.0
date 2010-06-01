From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 01 Jun 2010 09:17:36 -0400
Message-ID: <yq1wruiki33.fsf@sermon.lab.mkp.net>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	<yq1iq64kv9f.fsf@sermon.lab.mkp.net> <20100531144904.GL9453@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100531144904.GL9453@laptop> (Nick Piggin's message of "Tue, 1
	Jun 2010 00:49:04 +1000")
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Nick" == Nick Piggin <npiggin@suse.de> writes:

>> Yep, known bug.  Page writeback locking is messed up for buffer_head
>> users.  The extNfs folks volunteered to look into this a while back
>> but I don't think they have found the time yet.

Nick> What do you mean by messed up? Allowing modifications to the page
Nick> while it is under writeback? This is deliberate of course and not
Nick> limited to buffer_head users either.

Messed up in the sense that (at least last I looked) very few
buffer_head users were aware of the existence of the page writeback bit.

-- 
Martin K. Petersen	Oracle Linux Engineering
