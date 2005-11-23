From: =?iso-8859-1?q?Jos=E9_Luis_S=E1nchez?=
	<jsanchez@todounix.homeip.net>
Subject: Re: [sym2] Re: Problem with 2.6.14 and up...
Date: Thu, 24 Nov 2005 00:13:17 +0100
Message-ID: <200511240013.17352.jsanchez@todounix.homeip.net>
References: <20051123134327.GS1598@parisc-linux.org> <20051123143508.GT1598@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 81-202-88-178.user.ono.com ([81.202.88.178]:14012 "EHLO
	mafalda.lcv") by vger.kernel.org with ESMTP id S1030495AbVKWXNa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2005 18:13:30 -0500
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

Well, I have probed the Linux kernels from 2.6.11 to 2.6.14, without us=
ing the=20
NVidia display driver, only DRM and agpgart drivers. The problem appear=
s at=20
2.6.14, from 2.6.11 to 2.6.13 all works well. Now, I guess what is a pr=
oblem=20
related to the SCSI layer and not to the sym53c8xx_2 driver (2.6.14 don=
't=20
have any patch to the sym2 driver).

Thanks for your help and patience. :)
Jose Luis
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
