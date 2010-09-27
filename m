From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Mon, 27 Sep 2010 19:15:52 -0400
Message-ID: <20100927231551.GA15653@redhat.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
 <4CA0CC38.5010804@fusionio.com>
 <yq1pqvzcddq.fsf@sermon.lab.mkp.net>
 <4CA118FF.1080100@fusionio.com>
 <yq18w2mddav.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq18w2mddav.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-ext4@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 27 2010 at  6:36pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:
> Jens> Does mkfs do the right thing?
> 
> Depends on which mkfs it is. Mike has tested things and can chip in
> here...

I haven't test all mkfs.* but...

mkfs.xfs just works with 1M physical_block_size.

mkfs.ext4 won't by default but -F "fixes" that:

# mkfs.ext4 -b 4096 -F /dev/mapper/20017380023360006
mke2fs 1.41.12 (17-May-2010)
Warning: specified blocksize 4096 is less than device physical sectorsize 1048576, forced to continue
...

I'll check fdisk and parted tomorrow (I know lvm2 doesn't look at
physical_block_size).
