From: "Kotian, Deepak \( JBU  Mumbai \)" <Deepak.Kotian@patni.com>
Subject: RE: Is there a Comparison or Difference document between kernel 2.4 and kernel 2.6
Date: Sun, 31 Oct 2004 23:44:30 +0530
Message-ID: <374639AB1012AA4C840022842AA95BC20334FCAC@ruby.patni.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pcsmail.patni.com ([203.124.139.197]:61712 "EHLO
	pcsmail.patni.com") by vger.kernel.org with ESMTP id S261449AbUJaSSS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Oct 2004 13:18:18 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan-Benedict Glaw <jbglaw@lug-owl.de>, linux-scsi@vger.kernel.org

Thanks. that is correct.
=20
If there are drivers that are running on 2.4 will it work as it is on k=
ernel 2.6 or will there be any port issues,
has there any study carried out for that, please let me know.
=20
Thanks and Regards
Deepak
=20
=20
=20
=20

________________________________

=46rom: linux-scsi-owner@vger.kernel.org on behalf of Jan-Benedict Glaw
Sent: Sun 10/31/2004 11:39 PM
To: linux-scsi@vger.kernel.org
Subject: Re: Is there a Comparison or Difference document between kerne=
l 2.4 and kernel 2.6



On Sun, 2004-10-31 23:35:35 +0530, Kotian, Deepak ( JBU  Mumbai ) <Deep=
ak.Kotian@patni.com>
wrote in message <374639AB1012AA4C840022842AA95BC20334FCAB@ruby.patni.c=
om>:
> Is there a Comparison or Difference document between kernel 2.4 and k=
ernel 2.6
> Please let me know/

Overview in short:

- Better (TM) memory management
- All important subsystems now basically work O(1)
- More (and better) USB drivers
- Very good build system
- Still some work to be done to make it well-running on my VAX
  computers.

MfG, JBG

--
Jan-Benedict Glaw       jbglaw@lug-owl.de    . +49-172-7608481         =
    _ O _
"Eine Freie Meinung in  einem Freien Kopf    | Gegen Zensur | Gegen Kri=
eg  _ _ O
 fuer einen Freien Staat voll Freier B=FCrger" | im Internet! |   im Ir=
ak!   O O O
ret =3D do_actions((curr | FREE_SPEECH) & ~(NEW_COPYRIGHT_LAW | DRM | T=
CPA));


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
