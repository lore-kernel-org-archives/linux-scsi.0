From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH] fix implicit declaration compile warning in qla2xxx
Date: Mon, 17 Oct 2005 20:03:06 +0200
Message-ID: <9a8748490510171103s62bdb84ap3d0ba55b65af32e@mail.gmail.com>
References: <200510171959.23585.jesper.juhl@gmail.com>
	 <20051017180029.GA9192@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932079AbVJQSDL@vger.kernel.org>
In-Reply-To: <20051017180029.GA9192@plap.qlogic.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/17/05, Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:
> On Mon, 17 Oct 2005, Jesper Juhl wrote:
>
> > Fix warning about implicitly declared function in qla_rscn.c
> >   drivers/scsi/qla2xxx/qla_rscn.c:334: warning: implicit declaration of function `fc_remote_port_unblock'
> >
[snip]
>
> Sent earlier:
>
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112907350209822&w=2
>
Hmm, I guess I did a lousy job of searching the archives :(


> Awaiting inclusion.
>
Great :)


--
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
