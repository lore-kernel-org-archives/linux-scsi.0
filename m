From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH] Megaraid cleanup
Date: Tue, 10 Jan 2006 22:03:20 +0100
Message-ID: <9a8748490601101303r2e44e39at5f0f10bd82180add@mail.gmail.com>
References: <9738BCBE884FDB42801FAD8A7769C265142001@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.206]:50925 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932653AbWAJVDX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 16:03:23 -0500
Received: by wproxy.gmail.com with SMTP id 68so2568wri
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2006 13:03:22 -0800 (PST)
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C265142001@NAMAIL1.ad.lsil.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, "Kolli, Neela" <Neela.Kolli@engenio.com>, linux-scsi@vger.kernel.org

On 1/10/06, Ju, Seokmann <Seokmann.Ju@lsil.com> wrote:
> Hi,
> > Ok, I went into drivers/scsi/megaraid.c just to fix a few
> > compiler warnings,
> > but ended up doing a big spring-cleaning.
>
> Thank you for the patch first of all.

You're welcome.

> I would like to step through the changes in the patch and
> Will get back to you.
> I would think you've already verified the patch by testing
> The updated driver. Please confirm this.
>
As far as I could without having access to actual hardware, yes.
That means I've read through my changes and tried to verify them
visually/logically.
I've also compile tested it - it builds fine.
And I've also attempted to load it, and it fails (due to no hardware)
as it's supposed to.
Beyond that I'm unable to test it.

--
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
