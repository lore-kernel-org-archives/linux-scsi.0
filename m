From: =?iso-8859-1?q?Jos=E9_Luis_S=E1nchez?=
	<jsanchez@todounix.homeip.net>
Subject: Re: [sym2] Re: Problem with 2.6.14 and up...
Date: Wed, 23 Nov 2005 17:23:44 +0100
Message-ID: <200511231723.45088.jsanchez@todounix.homeip.net>
References: <20051123134327.GS1598@parisc-linux.org> <20051123143508.GT1598@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 81-202-88-178.user.ono.com ([81.202.88.178]:17307 "EHLO
	mafalda.lcv") by vger.kernel.org with ESMTP id S1751005AbVKWQXr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2005 11:23:47 -0500
In-Reply-To: <20051123143508.GT1598@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

El Mi=E9rcoles, 23 de Noviembre de 2005 15:35, Matthew Wilcox escribi=F3=
:
> On Wed, Nov 23, 2005 at 06:43:27AM -0700, Matthew Wilcox wrote:
> > 2. Can you try a later kernel?  If you have git, you can pull from
> >    git://git.kernel.org/pub/scm/linux/kernel/git/willy/sym2.git
> >    otherwise http://www.parisc-linux.org/~willy/sym2-2.2.2.diff app=
lies
> >    to a 2.6.15-rc1 kernel.
>
> I also noticed that akpm put out 2.6.15-rc2-mm1 today which includes =
the
> sym2 patches, so you could try that instead.

I've tried the patch in a 2.6.15-rc2 (patched OK) with the same result,=
 a bus=20
reset and a bunch of "phase change..." messages. Any probe what I can t=
ry to=20
stress the driver?

Another minor glitch never reported is what the device id 5 is a DDS-4 =
DAT,=20
with a UW interface. But the driver reports a synchronous speed of 20 M=
B/sec,=20
I don't know why...
In Solaris 10 x86 this DAT works very well at 40 MB/sec. This problem e=
xists=20
from all the 2.4 kernel series.

Thanks for your help.
Jose Luis
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
