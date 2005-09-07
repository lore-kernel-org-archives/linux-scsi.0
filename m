From: Andrew Morton <akpm@osdl.org>
Subject: Re: legacy megaraid driver bug in mm-series
Date: Wed, 7 Sep 2005 13:33:55 -0700
Message-ID: <20050907133355.54f3dd2d.akpm@osdl.org>
References: <0E3FA95632D6D047BA649F95DAB60E5703662B18@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:61081 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932236AbVIGUfr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 16:35:47 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5703662B18@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <sju@lsil.com>
Cc: linux-scsi@vger.kernel.org, ojbyer@usa.net

"Ju, Seokmann" <sju@lsil.com> wrote:
>
> Hi Andrew,
> On Wednesday, September 07, 2005 5:53 AM, Andrew Morton forwarded:
> > 2.6.11-mm1:	works
> > 2.6.11-mm4:	works
> > 2.6.12-rc5-mm1:	will not compile
> > 2.6.12-rc6-mm1:	works
> > 2.6.12-mm1:	will not compile megaraid driver
> > 2.6.12-mm2:	broken
> > 2.6.13-mm1:	broken
> > 
> > 2.6.12:		works
> > 2.6.13:		works
>
> Is there any precedence rule on the kernels?.
>

It's a bit weird, but the above are in chronological order.

Time order:

	2.6.12
	2.6.13-rc1
	2.6.13-rc2
	2.6.13
	2.6.14-rc1

etc.  And -mm kernels are just the current Linus kernel with -mmX appended.

> I wonder which kernel is latest in between 2.6.12 and 2.6.12-mmx.

2.6.12-mmX

> I assume 2.6.12-mmx is later than 2.6.12.

Correct.

