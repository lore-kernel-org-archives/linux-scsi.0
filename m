From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target updates for v4.4-rc1
Date: Fri, 13 Nov 2015 11:55:35 -0800
Message-ID: <1447444535.23126.119.camel@haakon3.risingtidesystems.com>
References: <1447408790.23126.109.camel@haakon3.risingtidesystems.com>
	 <CA+55aFy0XCw5d4DVajRbG=jnR_VEUQNu2thf5VqAUsi1ihw3GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFy0XCw5d4DVajRbG=jnR_VEUQNu2thf5VqAUsi1ihw3GQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Felipe Balbi <balbi@ti.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-11-13 at 09:48 -0800, Linus Torvalds wrote:
> On Fri, Nov 13, 2015 at 1:59 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > Please pull from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next
> 
> Ok, not only was this pull request late, it had a semantic conflict
> that causes the end result to not compile.
> 
> You must have known about that conflict, since it was reported for
> linux-next. Alexander Shishkin had a patch for it.
> 
> This is the kind of thing you should talk about in your pull request.
> Yes, I find these things out. Yes, I can fix it up myself. But the
> whole point of linux-next is finding these things and making the
> parties aware of it.
> 
> If you don't then use the linux-next information when you send my pull
> request, exactly *what* was the point of it ever being in linux-next
> in the first place?

Ugh.

> 
> I'm annoyed. This is not the kind of sh*t I want to deal with on the
> Friday before the merge window closes.
> 
> I've unpulled it for now. And I'm not sure I want to pull it later
> when I'm less annoyed.
> 
> So just to make it really clear to people: if you ignore the reports
> from linux-next, then I will damn well ignore you. Comprende? Fair is
> fair.

Would you accept an updated PULL request with Alexander's patch, or
prefer this whole series wait until v4.5..?

Certainly it's my fault for not getting it sent out earlier, but the
patches themselves, minus Alexander's extra hwtracing fix-up, have seen
enough review + build testing to be uncontroversial at this point.

--nab
