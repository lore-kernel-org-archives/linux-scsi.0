From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target: Updates for v3.3-rc1 (round 1)
Date: Wed, 11 Jan 2012 11:32:57 -0800
Message-ID: <1326310377.20199.16.camel@haakon2.linux-iscsi.org>
References: <1326221809.14089.23.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-qs3fE8yZaKQ+kzpsSsX1PyXE09wBzxnUi55GZ5j4TJKg@mail.gmail.com>
	 <1326223998.14089.26.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-oqsimTj6fRa=euEegH8Sqg=N_j4vXs6u=j31Za+WBKOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-oqsimTj6fRa=euEegH8Sqg=N_j4vXs6u=j31Za+WBKOw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-01-11 at 07:57 +0100, Bart Van Assche wrote:
> 2012/1/10 Nicholas A. Bellinger <nab@linux-iscsi.org>:
> > These are all very minor and did not warrant another full RFC posting.
> 
> There is a reason why the ib_srpt patch should have been reposted:
> Last WQE handling is still wrong, despite a patch being available
> (http://www.spinics.net/lists/linux-rdma/msg09982.html).
> 

This patch was applied to lio-core.git, but considering that I've
received zero testing feedback on this I elected not to include it in
target-pending for the initial merge.

Once it can get some real testing it will be included into rc-fixes
along with the rest of the post merge-window updates.  So please, lets
not try to delay the merging of this driver (again) over bits that will
be addressed post -rc1.

Thanks,

--nab
