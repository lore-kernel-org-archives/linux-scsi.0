From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target: Updates for v3.2-rc1 (round one)
Date: Tue, 25 Oct 2011 02:45:24 -0700
Message-ID: <1319535924.18871.11.camel@haakon2.linux-iscsi.org>
References: <1319533236.17450.338.camel@haakon2.linux-iscsi.org>
	 <CA+55aFyeCfXV9Fpg9vZywmHtP3PR8+voZpampVqW8TAfCvLv3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyeCfXV9Fpg9vZywmHtP3PR8+voZpampVqW8TAfCvLv3Q@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-10-25 at 11:29 +0200, Linus Torvalds wrote:
> On Tue, Oct 25, 2011 at 11:00 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> >  36 files changed, 937 insertions(+), 2068 deletions(-)
> 
> Hmm. This is not what I get. It might be a git version issue or diff
> algorithm one - although that's actually pretty unusual. Do you do
> something odd/special?
> 

I don't believe so.  The diff-stat was generated using git-format-patch
from target-pending.git with git 1.5.6.5 from the following HEAD:

commit 65112dccf8a113737684366349d7f9ec373ddc47
Merge: bbf5e97... 9d1e397...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Oct 10 14:53:11 2011 +1200

    Merge git://git.samba.org/sfrench/cifs-2.6

After pulling into a linux-next tree from 20111014, this does appear
different slightly different for some reason..?

 30 files changed, 937 insertions(+), 2052 deletions(-)

I'm certain it's from the same commit that starts the series here: 

commit 9375b1bfd2555c8bc828d394a4419a212b46ba71
Author: Jesper Juhl <jj@chaosbits.net>
Date:   Mon Aug 1 23:29:11 2011 +0200

    target: Remove unneeded version.h includes

--nab
