From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Date: Wed, 23 Feb 2011 12:24:47 -0800
Message-ID: <20110223202446.GG4020@noexit>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
 <yq1vd0cf26f.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1vd0cf26f.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: djwong@us.ibm.com, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 22, 2011 at 11:45:44AM -0500, Martin K. Petersen wrote:
> Also, DIX is only the tip of the iceberg. Many other impending
> technologies feature checksums and require pages to be stable during I/O
> due to checksumming, encryption and so on.
> 
> The VM is already trying to do the right thing. We just need the
> relevant filesystems to catch up.

	ocfs2 handles stable metadata for its checksums when feeding
things to the journal.  If we're doing pagecache-based I/O, is the
pagecache going to help here for data?
 
Joel

-- 

"Gone to plant a weeping willow
 On the bank's green edge it will roll, roll, roll.
 Sing a lulaby beside the waters.
 Lovers come and go, the river roll, roll, rolls."

			http://www.jlbec.org/
			jlbec@evilplan.org
