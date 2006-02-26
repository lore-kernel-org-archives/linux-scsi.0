From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH] silence gcc warning about possibly uninitialized use of variable in scsi_scan
Date: Sun, 26 Feb 2006 20:01:22 +0100
Message-ID: <9a8748490602261101q39f4cf8eqabe0143921389ce6@mail.gmail.com>
References: <200602261639.15657.jesper.juhl@gmail.com>
	 <1140978084.3692.6.camel@mulgrave.il.steeleye.com>
	 <9a8748490602261023j46eb39f2peaa080d737fee5e1@mail.gmail.com>
	 <1140980377.3692.9.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.202]:1890 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932085AbWBZTBX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2006 14:01:23 -0500
Received: by zproxy.gmail.com with SMTP id f1so726503nzc
        for <linux-scsi@vger.kernel.org>; Sun, 26 Feb 2006 11:01:22 -0800 (PST)
In-Reply-To: <1140980377.3692.9.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-kernel@vger.kernel.org, Eric Youngdale <ericy@cais.com>, Eric Youngdale <eric@andante.org>, linux-scsi@vger.kernel.org

On 2/26/06, James Bottomley <James.Bottomley@steeleye.com> wrote:
> On Sun, 2006-02-26 at 19:23 +0100, Jesper Juhl wrote:
> > > gcc version 4.0.3 20051201 (prerelease) (Debian 4.0.2-5)
> > >
> > > Doesn't give this warning.  And, since the loop has fixed parameters,
> > > gcc should see not only that it's always executed, but that it could be
> > > unrolled.
> > >
> > > Which version is causing the problem?
> > >
> > 2.6.16-rc4-mm2 build with gcc 3.4.5
>
> I also tried with
>
> gcc version 3.3.5 (Debian 1:3.3.5-13)
>
> which likewise fails to give this warning, so I really think this is a
> bug in your particular version of gcc.
>

Hmm, it's quite reproducible and the gcc 3.4.5 I have here is not
patched by the distribution (Slackware). If you want I can send you
the .config that results in the warning..

--
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
