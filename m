From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 00/42] v7: separate operations from flags in the
 bio/request structs
Date: Wed, 4 May 2016 13:04:45 -0500
Message-ID: <572A39BD.8020405@redhat.com>
References: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
 <x49d1p2c1nx.fsf@segfault.boston.devel.redhat.com>
 <572A36BF.3070208@redhat.com>
 <x49a8k5aen2.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <x49a8k5aen2.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
List-Id: linux-scsi@vger.kernel.org

On 05/04/2016 12:58 PM, Jeff Moyer wrote:
> Mike Christie <mchristi@redhat.com> writes:
> 
>> On 05/03/2016 03:44 PM, Jeff Moyer wrote:
>>> Hi, Mike,
>>>
>>> That git tree doesn't seem to exist.  I did manage to apply your patch
>>> set on top of next-20160415, though.
>>>
>>> So... what testing did you do? ;-) I ran into the following problems
>>
>> I normally run xfstests and run it on my daily workstation and laptop. I
>> did not do this for every FS this time and hit a regression.
>>
>> What FS were you using?
> 
> I'm using xfs, scsi disk, no blk-mq, no dm.
> 
>>> - git clone fails
>>> - yum segfaults
>>
>> In v7/v6, I missed a new submit_bio call, so I hit issues like the two
>> above. I have this fixed in the next version.
> 
> OK, does this mean you're posting another version, or you already did
> and I somehow missed it?
> 

I did not repost yet. I am still testing. Jens had me add some wrappers
around the operation access, so because of my last screw up and the
wrapper change affected all my patches I am redoing all my testing.
