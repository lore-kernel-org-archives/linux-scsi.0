From: Fabio Coatti <cova@ferrara.linux.it>
Subject: Re: 2.6.10-rc2-mm2 usb storage still oopses
Date: Tue, 30 Nov 2004 10:13:45 +0100
Message-ID: <200411301013.46888.cova@ferrara.linux.it>
References: <200411182203.02176.cova@ferrara.linux.it> <20041129163231.33affbde.akpm@osdl.org> <1101784930.2022.116.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 4s.enrico.unife.it ([192.167.219.82]:34998 "EHLO
	quatresse.ferrara.linux.it") by vger.kernel.org with ESMTP
	id S261876AbUK3JNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2004 04:13:50 -0500
In-Reply-To: <1101784930.2022.116.camel@mulgrave>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, Pete Zaitcev <zaitcev@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

Alle 04:22, marted=EC 30 novembre 2004, James Bottomley ha scritto:


> > >
> > > This looks as if SCSI falls victim of the general problem which u=
b
> > > addresses with the following fragment:
> >
> > Guys, is this problem still present in Linus's tree?  If so, is a f=
ix for
> > 2.6.10 looking feasible?
>
> Al Viro has a tentative one at
>
> http://ftp.linux.org.uk/pub/people/viro/register_disk-hack
>
> If someone could try it out and verify that it fixes the problem, we
> could put it in.


Now I'm at work; this evening I'll try and I'll report asap the results=
=2E on=20
wich kernel does it apply? last kernels that I've tried are 2.6.10-rcX-=
mmY=20
series, but I can try the most suitable version for debugging, just let=
 me=20
know.



--=20
=46abio "Cova" Coatti    http://members.ferrara.linux.it/cova    =20
=46errara Linux Users Group           http://ferrara.linux.it
GnuPG fp:9765 A5B6 6843 17BC A646  BE8C FA56 373A 5374 C703
Old SysOps never die... they simply forget their password.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
