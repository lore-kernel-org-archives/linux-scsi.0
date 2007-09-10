From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: 2.6.23-rc4-mm1
Date: Mon, 10 Sep 2007 21:38:04 +0200
Message-ID: <64bb37e0709101238s18c929b2l131d96fc40af208c@mail.gmail.com>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
	 <20070910174926.GC30335@shadowen.org>
	 <20070910111926.9c942358.akpm@linux-foundation.org>
	 <64bb37e0709101159v47f586aby7f078ef1db5cbc39@mail.gmail.com>
	 <20070910122038.1f1bb006.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070910122038.1f1bb006.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org, mel@csn.ul.ie, Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 9/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 10 Sep 2007 20:59:49 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
>
> > On 9/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Mon, 10 Sep 2007 18:49:26 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> > I reported a similar problem on Sep 1, but until now got no response.
>
> You still haven't had a response ;)  Let's add a cc.

But the mail from Andy was a nice point to try to another cc, i.e.
linux-scsi that you added. :)

> Oh, you reported it against 2.6.23-rc4-mm1
> (http://lkml.org/lkml/2007/9/1/92) and I did cc linux-ide in my response.
>
[snip]
> Andy is using qla1280.  You're using sata.  So it's probably a different
> bug, with the same symptoms.

Yes, but you (Andrew) also said in response to Andy: "If it's not that then
perhaps something in scsi core broke, dunno." So I wanted to add that
my problem migth point this bug into the core direction.

> Can you please confirm that this bug is present in -mm and not present in
> mainline (yet)?

Currently using 2.6.23-rc3-mm1, that works for me.
Now downloading 2.6.23-rc5-git1...

Torsten
