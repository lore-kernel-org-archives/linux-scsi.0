From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [GIT PULL] target: Updates for v3.3-rc1 (round 1)
Date: Wed, 11 Jan 2012 07:57:41 +0100
Message-ID: <CAO+b5-oqsimTj6fRa=euEegH8Sqg=N_j4vXs6u=j31Za+WBKOw@mail.gmail.com>
References: <1326221809.14089.23.camel@haakon2.linux-iscsi.org>
	<CAO+b5-qs3fE8yZaKQ+kzpsSsX1PyXE09wBzxnUi55GZ5j4TJKg@mail.gmail.com>
	<1326223998.14089.26.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1326223998.14089.26.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@purestorage.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

2012/1/10 Nicholas A. Bellinger <nab@linux-iscsi.org>:
> These are all very minor and did not warrant another full RFC posting.

There is a reason why the ib_srpt patch should have been reposted:
Last WQE handling is still wrong, despite a patch being available
(http://www.spinics.net/lists/linux-rdma/msg09982.html).

Bart.
