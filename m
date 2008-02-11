From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [SCSI] ses: fix memory leaks
Date: Mon, 11 Feb 2008 12:25:03 -0800
Message-ID: <200802111225.04021.yinghai.lu@sun.com>
References: <200802090413.53275.yinghai.lu@sun.com>
 <1202747000.3122.28.camel@localhost.localdomain>
 <1202749326.3122.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <1202749326.3122.39.camel@localhost.localdomain>
Content-disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, kristen.c.accardi@intel.com
List-Id: linux-scsi@vger.kernel.org

On Monday 11 February 2008 09:02:06 am James Bottomley wrote:
> 
> On Mon, 2008-02-11 at 10:23 -0600, James Bottomley wrote:
> > On Sun, 2008-02-10 at 23:25 -0800, Yinghai Lu wrote:
> > > please check it...
> > 
> > This one looks perfect, thanks!
> 
> Well, nearly perfect.  I corrected this typo:
> 
> +       if (!buf)
> +               goto simple_polulate;
>                             ^^^^^^^^
> 
> Which a compile check before you submitted the patch would have picked
> up ...

sorry for that.
