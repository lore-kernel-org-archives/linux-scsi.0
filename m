From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH] silence gcc warning about possibly uninitialized use of variable in scsi_scan
Date: Sun, 26 Feb 2006 21:41:37 +0100
Message-ID: <9a8748490602261241j6e55cf45g5c4b6ddd211f85c3@mail.gmail.com>
References: <200602261639.15657.jesper.juhl@gmail.com>
	 <1140978084.3692.6.camel@mulgrave.il.steeleye.com>
	 <9a8748490602261023j46eb39f2peaa080d737fee5e1@mail.gmail.com>
	 <1140980377.3692.9.camel@mulgrave.il.steeleye.com>
	 <9a8748490602261101q39f4cf8eqabe0143921389ce6@mail.gmail.com>
	 <1140981714.3692.12.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.197]:35939 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751209AbWBZUli convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2006 15:41:38 -0500
Received: by wproxy.gmail.com with SMTP id 69so1014471wri
        for <linux-scsi@vger.kernel.org>; Sun, 26 Feb 2006 12:41:37 -0800 (PST)
In-Reply-To: <1140981714.3692.12.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>, linux-scsi@vger.kernel.org

On 2/26/06, James Bottomley <James.Bottomley@steeleye.com> wrote:
> On Sun, 2006-02-26 at 20:01 +0100, Jesper Juhl wrote:
> > Hmm, it's quite reproducible and the gcc 3.4.5 I have here is not
> > patched by the distribution (Slackware). If you want I can send you
> > the .config that results in the warning..
>
> I really don't think it's a config issue.  scsi_probe_lun() is always
> compiled in if CONFIG_SCSI is set.  I think you have a compiler problem.
>

I must admit I think the compiler is OK.
I have two different boxes with gcc 3.4.5 and they both give the same
warning (not to mention that that gcc builds everything I've thrown at
it correctly).
But nevermind, it's just a silly little warning - just leave it be.

--
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
