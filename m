From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Wed, 2 Jun 2010 15:37:48 +0200
Message-ID: <20100602133748.GA11196@schmichrtp.mainz.de.ibm.com>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
 <20100531144648.GA19068@schmichrtp.mainz.de.ibm.com>
 <yq11vcqlwp8.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq11vcqlwp8.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 01, 2010 at 09:16:35AM -0400, Martin K. Petersen wrote:
> >>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:
> 
> >> Yep, known bug.  Page writeback locking is messed up for buffer_head
> >> users.  The extNfs folks volunteered to look into this a while back
> >> but I don't think they have found the time yet.
> 
> Christof> Thanks for the info. This means that this bug appears with all
> Christof> filesystems?
> 
> XFS and btrfs should be fine.

XFS looks good in my test, thanks for the hint. I am going to use XFS
for anything related to DIF for now. It would be nice to have a
solution that works for all filesystems, but it looks like this will
take some time and work.

Christof
