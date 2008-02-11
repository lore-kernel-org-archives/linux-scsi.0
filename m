From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI] ses: fix memory leaks
Date: Mon, 11 Feb 2008 11:02:06 -0600
Message-ID: <1202749326.3122.39.camel@localhost.localdomain>
References: <200802090413.53275.yinghai.lu@sun.com>
	 <200802091515.48076.yinghai.lu@sun.com>
	 <1202704118.3136.79.camel@localhost.localdomain>
	 <200802102325.26538.yinghai.lu@sun.com>
	 <1202747000.3122.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1202747000.3122.28.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, kristen.c.accardi@intel.com
List-Id: linux-scsi@vger.kernel.org


On Mon, 2008-02-11 at 10:23 -0600, James Bottomley wrote:
> On Sun, 2008-02-10 at 23:25 -0800, Yinghai Lu wrote:
> > please check it...
> 
> This one looks perfect, thanks!

Well, nearly perfect.  I corrected this typo:

+       if (!buf)
+               goto simple_polulate;
                            ^^^^^^^^

Which a compile check before you submitted the patch would have picked
up ...

James


