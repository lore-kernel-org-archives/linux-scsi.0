From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [Lsf-pc] [dm-devel]  [LSF/MM TOPIC] a few storage topics
Date: Thu, 26 Jan 2012 05:29:03 -0700
Message-ID: <5B229F2F-4B0D-4AC1-A726-9E0CC8CE5FBE@dilger.ca>
References: <x49fwf5kmbl.fsf@segfault.boston.devel.redhat.com> <20120124184054.GA23227@infradead.org> <20120124190732.GH4387@shiny> <x49vco0kj5l.fsf@segfault.boston.devel.redhat.com> <20120124200932.GB20650@quack.suse.cz> <x49pqe8kgej.fsf@segfault.boston.devel.redhat.com> <20120124203936.GC20650@quack.suse.cz> <20120125032932.GA7150@localhost> <F6F2DEB8-F096-4A3B-89E3-3A132033BC76@dilger.ca> <20120125063552.GA27375@localhost> <20120125140048.GC32361@quack.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120125140048.GC32361@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Wu Fengguang <fengguang.wu@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, "neilb@suse.de Brown" <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>, "dm-devel@redhat.com development" <dm-devel@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>, "linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org, Chris Mason <chris.mason@oracle.com>, "Darrick J.Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 2012-01-25, at 7:00 AM, Jan Kara wrote:
> On Wed 25-01-12 14:35:52, Wu Fengguang wrote:
>> On Tue, Jan 24, 2012 at 11:15:13PM -0700, Andreas Dilger wrote:
>>> I'm all in favour of 1MB (aligned) readahead.
>> 
>> 1MB readahead aligned to i*1MB boundaries? I like this idea. It will
>> work well if the filesystems employ the same alignment rule for large
>> files.
> 
> Yeah. Clever filesystems (e.g. XFS) can be configured to align files e.g.
> to raid stripes AFAIK so for them this could be worthwhile.

Ext4 will also align IO to 1MB boundaries (from the start of LUN/partition)
by default.  If the mke2fs code detects the underlying RAID geometry (or the
sysadmin sets this manually with tune2fs) it will store this in the superblock
for the allocator to pick a better alignment.

Cheers, Andreas





