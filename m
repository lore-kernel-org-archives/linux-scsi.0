From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: Conversion to generic boolean
Date: Mon, 28 Aug 2006 11:45:21 +0200
Message-ID: <9a8748490608280245n3228aaf0t99a50ad6f879e7e0@mail.gmail.com>
References: <44EFBEFA.2010707@student.ltu.se>
	 <20060828093202.GC8980@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932483AbWH1JpX@vger.kernel.org>
In-Reply-To: <20060828093202.GC8980@infradead.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Richard Knutsson <ricknu-0@student.ltu.se>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 28/08/06, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Aug 26, 2006 at 05:24:42AM +0200, Richard Knutsson wrote:
> > Hello
> >
> > Just would like to ask if you want patches for:
>
> Total NACK to any of this boolean ididocy.  I very much hope you didn't
> get the impression you actually have a chance to get this merged.
>
> >
> > * (Most importent, may introduce bugs if left alone)
> > Fixing boolean checking, ex:
> > if (bool == FALSE)
> > to
> > if (!bool)
>
> this one of course makes sense, but please do it without introducing
> any boolean type.  Getting rid of all the TRUE/FALSE defines and converting
> all scsi drivers to classic C integer as boolean semantics would be
> very welcome janitorial work.
>
If you'll take such patches I'd be willing to clean up a few drivers..
 Any specific ones you'd like me to start with?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
