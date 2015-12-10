From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] [SCSI] osd: fix signed char versus %02x issue
Date: Thu, 10 Dec 2015 11:25:59 -0800
Message-ID: <1449775559.12972.11.camel@perches.com>
References: <1449584716-21093-1-git-send-email-linux@rasmusvillemoes.dk>
	 <yq1zixi186s.fsf@sermon.lab.mkp.net>
	 <CAHp75Vcze4m8OeY=0wuiUtE_LgoifmmhdRKM2sQTAT-_Y3DFjg@mail.gmail.com>
	 <yq1fuza15hy.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1fuza15hy.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Boaz Harrosh <ooo@electrozaur.com>, "James E.J. Bottomley" <JBottomley@odin.com>, osd-dev@open-osd.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-12-10 at 14:13 -0500, Martin K. Petersen wrote:
> > > > > > "Andy" == Andy Shevchenko <andy.shevchenko@gmail.com> writes:
> 
> Andy> I have several patches on SCSI subsytem like this one. Some of
> Andy> them didn't manage kernel (even having Ack!) for years already.
> Andy> Is it okay if I collect them together and send a bunch once again
> 
> Re-sending to linux-scsi is fine. The trick is finding people willing to
> review them...

Generally speaking, it hasn't been for lack of review.

SCSI has been one of the slowest subsystems to apply
simple defect correction (not whitespace style) patches.

Mostly these patches have been ignored.
