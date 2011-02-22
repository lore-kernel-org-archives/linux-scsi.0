From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation problem
Date: Tue, 22 Feb 2011 11:45:44 -0500
Message-ID: <yq1vd0cf26f.fsf@sermon.lab.mkp.net>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110222020022.GH32261@tux1.beaverton.ibm.com> (Darrick
	J. Wong's message of "Mon, 21 Feb 2011 18:00:22 -0800")
Sender: linux-fsdevel-owner@vger.kernel.org
To: djwong@us.ibm.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Darrick" == Darrick J Wong <djwong@us.ibm.com> writes:

Darrick> Unfortunately, I didn't get a sense that any sort of consensus
Darrick> had been reached

We had a session on this topic at the storage workshop in Auguest. The
consensus was that filesystems really need to handle this.

Also, DIX is only the tip of the iceberg. Many other impending
technologies feature checksums and require pages to be stable during I/O
due to checksumming, encryption and so on.

The VM is already trying to do the right thing. We just need the
relevant filesystems to catch up.

-- 
Martin K. Petersen	Oracle Linux Engineering
