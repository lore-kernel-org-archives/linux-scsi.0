From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [patch 08/17] Fix a potential NULL pointer deref in the aic7xxx, ahc_print_register() function
Date: Sat, 6 Oct 2007 00:23:54 +0200
Message-ID: <9a8748490710051523k44bb1445jc9709f6e8aacc208@mail.gmail.com>
References: <200710022138.l92Lc4iM023579@imap1.linux-foundation.org>
	 <1191618992.3475.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:31898 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758459AbXJEWXz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 18:23:55 -0400
Received: by py-out-1112.google.com with SMTP id u77so1223408pyb
        for <linux-scsi@vger.kernel.org>; Fri, 05 Oct 2007 15:23:54 -0700 (PDT)
In-Reply-To: <1191618992.3475.32.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On 05/10/2007, James Bottomley <James.Bottomley@steeleye.com> wrote:
> On Tue, 2007-10-02 at 14:38 -0700, akpm@linux-foundation.org wrote:
> > From: Jesper Juhl <jesper.juhl@gmail.com>
> >
> > The Coverity checker noticed that we have a potential NULL pointer
> > deref in drivers/scsi/aic7xxx/aic7xxx_core.c::ahc_print_register().
> > This patch handles it by adding the same test against NULL that is
> > used elsewhere in the same function.
> >
> > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> No.  Reasons formerly given here:
>
> http://marc.info/?l=linux-scsi&m=118632919511846&w=2
>

The reasons that patch sticks around was given by Andrew in a mail
send to me, you and Justin Gibbs on Aug 8.

My reply to that mail (including Andrew's original) is below, but you
should be able to also find it in your own archives.

Basically Andrew said:
"That's the sort of patch I keep around to prevent the issue from
getting swept under the table.  This usually results in me sitting on
the sorry thing for literally years :("

---[ quote from old email - start ]---
>       from         Jesper Juhl <jesper.juhl@gmail.com>
> 	to	 	Andrew Morton <akpm@linux-foundation.org>	
> 	cc	
>  	James Bottomley <James.Bottomley@steeleye.com>,
> Justin T. Gibbs <gibbs@scsiguy.com>	
> 	date		8 Aug 2007 00:43	
> 	subject		Re: + avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch added to > -mm tree	
> 	mailed-by		gmail.com	
> On 08/08/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 8 Aug 2007 00:26:43 +0200
> > "Jesper Juhl" <jesper.juhl@gmail.com> wrote:
> >
> > > This reply was meant for
> > >
> > > > The patch titled
> > > >     Fix a potential NULL pointer deref in the aic7xxx, ahc_print_register() function
> > > > has been added to the -mm tree.  Its filename is
> > > >     fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
> > > >
> >
> > That's the sort of patch I keep around to prevent the issue from getting
> > swept under the table.  This usually results in me sitting on the sorry
> > thing for literally years :(
> >
> Ok, in that case you may want to keep it around in -mm despite James'
> objections - I'll leave that up to you. But it probably shouldn't move
> towards mainline...
>
> > Feel free to send a replacement patch which gets us closer to the real fix.
> > Remove all the NULL tests, maybe.
> >
> I don't have a good idea on how to solve this better at the moment.
> But if I come up with something I'll be sure to send it to you and
> James.
>
---[ quote from old email - end ]---


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
