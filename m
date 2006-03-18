From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH] fix potential return of uninitialized variable in scsi_scan (resend)
Date: Sun, 19 Mar 2006 00:22:24 +0100
Message-ID: <9a8748490603181522s113cd1acn20d97da825c4fd7@mail.gmail.com>
References: <200603182242.52507.jesper.juhl@gmail.com>
	 <1142723433.3773.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.206]:23202 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751131AbWCRXW2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 18:22:28 -0500
Received: by wproxy.gmail.com with SMTP id 70so755423wra
        for <linux-scsi@vger.kernel.org>; Sat, 18 Mar 2006 15:22:25 -0800 (PST)
In-Reply-To: <1142723433.3773.16.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

On 3/19/06, James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
> On Sat, 2006-03-18 at 22:42 +0100, Jesper Juhl wrote:
> > ( The patch below was already send on March 9, 2006. )
> > ( This is a resend, re-diff'ed against 2.6.16-rc6    )
> >
> >
> > The coverity checker found out that we potentially return sdev uninitialized.
> > This should fix coverity #879
>
> The fix for this is already in scsi-misc.
>
Ok, I was unaware of that.
I'll try to remember to check that git tree in the future.

Thanks.


--
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
