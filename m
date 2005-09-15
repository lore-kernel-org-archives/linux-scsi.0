From: Lukasz Kosewski <lkosewsk@gmail.com>
Subject: Re: [PATCH 3/3] Add disk hotswap support to libata RESEND #2
Date: Thu, 15 Sep 2005 00:40:27 -0400
Message-ID: <355e5e5e050914214025feee82@mail.gmail.com>
References: <355e5e5e05080103021a8239df@mail.gmail.com>
	 <4789af9e050823124140eb924f@mail.gmail.com>
	 <4789af9e050823154364c8e9eb@mail.gmail.com>
	 <430BA990.9090807@mvista.com> <430BCB41.5070206@s5r6.in-berlin.de>
	 <355e5e5e05082407031138120a@mail.gmail.com>
	 <4789af9e05082408111c4a6294@mail.gmail.com>
	 <4789af9e05082409121cc6870@mail.gmail.com>
	 <4789af9e0508291223435f174@mail.gmail.com>
	 <4789af9e05090612023fb8517c@mail.gmail.com>
Reply-To: lkosewsk@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4789af9e05090612023fb8517c@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: jim.ramsay@gmail.com
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 9/6/05, Jim Ramsay <jim.ramsay@gmail.com> wrote:
> However, I have seen the occasion where a single IRQ is used to signal
> both a DMA completion AND a hotplug event.  Of course in this case the
> hotplug event itself would be ignored completely.
> 
> So I would recommend getting rid of that check entirely.

Hey Jim,

Not that I disbelieve you, but do you have an example of a controller
where this happens?  I've done a lot of testing and never seen this...

Luke Kosewski
