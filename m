From: Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] target: Updates for v3.2-rc1 (round one)
Date: Tue, 25 Oct 2011 11:42:32 +0200
Message-ID: <20111025094232.GA17763@lst.de>
References: <1319533236.17450.338.camel@haakon2.linux-iscsi.org> <CA+55aFyeCfXV9Fpg9vZywmHtP3PR8+voZpampVqW8TAfCvLv3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyeCfXV9Fpg9vZywmHtP3PR8+voZpampVqW8TAfCvLv3Q@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 25, 2011 at 11:29:39AM +0200, Linus Torvalds wrote:
> On Tue, Oct 25, 2011 at 11:00 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > ?36 files changed, 937 insertions(+), 2068 deletions(-)
> 
> Hmm. This is not what I get. It might be a git version issue or diff
> algorithm one - although that's actually pretty unusual. Do you do
> something odd/special?

It's mostly me looking at the code and factoring code and removing
unneeded things from old versions.
