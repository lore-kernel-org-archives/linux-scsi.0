From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2 of 8] block: Export I/O topology for block devices and  partitions
Date: Thu, 23 Apr 2009 14:34:39 -0400
Message-ID: <yq163gvb4n4.fsf@sermon.lab.mkp.net>
References: <patchbomb.1240464567@sermon.lab.mkp.net>
	<cbdae69a14895dab8ba7.1240464569@sermon.lab.mkp.net>
	<20090423105145.GW4593@kernel.dk>
	<20090423181312.GA8768@mars.virtualiron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090423181312.GA8768@mars.virtualiron.com> (Konrad Rzeszutek's
	message of "Thu, 23 Apr 2009 14:13:12 -0400")
Sender: linux-ide-owner@vger.kernel.org
To: Konrad Rzeszutek <konrad@virtualiron.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Konrad" == Konrad Rzeszutek <konrad@virtualiron.com> writes:

Konrad> Should there be a comment/Documentation blurb on how to
Konrad> remediate a misaligment? Such as how to modify the partition
Konrad> tables and what to look for in the BIOS (if anything) to take
Konrad> advantage of 4K sectors?

My patches provide the infrastructure for partitioning tools etc. to
start doing the right thing.  The parted/util-linux people know that the
support is coming.

There are lots of considerations in this department due to compatibility
with Windows, BIOS int13 calls and EFI.  I'll leave it up to the tools
people to define how to deal with alignment and padding in each case.

-- 
Martin K. Petersen	Oracle Linux Engineering
