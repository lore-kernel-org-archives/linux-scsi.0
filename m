From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target: Updates for v3.3-rc1 (round 1)
Date: Tue, 10 Jan 2012 11:33:18 -0800
Message-ID: <1326223998.14089.26.camel@haakon2.linux-iscsi.org>
References: <1326221809.14089.23.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-qs3fE8yZaKQ+kzpsSsX1PyXE09wBzxnUi55GZ5j4TJKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-qs3fE8yZaKQ+kzpsSsX1PyXE09wBzxnUi55GZ5j4TJKg@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-01-10 at 19:19 +0000, Bart Van Assche wrote:
> 2012/1/10 Nicholas A. Bellinger <nab@linux-iscsi.org>
> > *) Initial merge for the SRP target (ib_srpt) fabric module (bart)
> 
> As far as I know the last time that patch was posted for review is
> November 4 (http://permalink.gmane.org/gmane.linux.scsi.target.devel/420).
> The date of the ib_srpt commit is December 16
> (http://git.kernel.org/?p=linux/kernel/git/nab/target-pending.git;a=commitdiff;h=a42d985bd5b234da8b61347a78dc3057bf7bb94d).
> The two patches aren't identical. That makes me wonder whether that
> patch should have been reposted for review ?
> 

Hi Bart,

The changes since the Nov 4 RFC are listed in the patch commit log:

ib_srpt: Make compilation with BUG=n proceed`
ib_srpt: Use new target_core_fabric.h include
ib_srpt: Check hex2bin() return code to silence build warning

These are all very minor and did not warrant another full RFC posting.

--nab
