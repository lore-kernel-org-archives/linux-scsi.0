From: rp11@poczta.onet.pl
Subject: Fw: Re: SCSI common code for probeing for devices
Date: Sun, 21 Mar 2004 14:58:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040321135828Z144868-29812+44813@kps2.test.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2k.poczta.onet.pl ([213.180.130.34]:4763 "EHLO
	smtp2k.poczta.onet.pl") by vger.kernel.org with ESMTP
	id S263651AbUCUN6b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Mar 2004 08:58:31 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

Have any one else seen this problem of atp870u.o driver NOT detecting t=
he SCSI devices with ID in range 8..15? (my initial e-mail appended).

The driver workes OK with 2.4.22.

Since my e-mail to James I tried 2.6.4 with the same results as 2.6.3.

BTW: I'm not on the list (yet :), pls respond directly.

In any case, as I said in my initial e-mail to James, I can do further =
tests/provide more info if guided. Without that I'm stuck - I cannot tr=
ace the problem anywhere deeper.

Thenx,

-R

U=BFytkownik James Bottomley <James.Bottomley@steeleye.com> napisa=B3:
>On Sun, 2004-03-14 at 15:14, rp11@poczta.onet.pl wrote:
>> I\'ve just tried the new 2.6.3 kernel with my hardware, and I wasn\'=
t able to bring up the scsi subsytem I currently use with 2.4.22.
>> I  have "00:08.0 SCSI storage controller: Artop Electronic Corp AEC6=
712UW SCSI (rev 01)" as my host controler - it works with the new drive=
r (as of 2.6.3) only for devices with ID lower then 7.
>> The driver [atp870u] sets host->max_id =3D 16 only for p->chip_veru =
=3D=3D 4.
>> My p->chip_veru is =3D=3D0, but when I FORCE host->max_id =3D 16, th=
e scan goes whtough all 0..15 devices, but those above nr.7 are NOT det=
ected even so.
>>=20
>> By now, I don\'t quite know, where to look for the missbehaveing of =
the driver (whether is some \'common code\' or speciffic driver routine=
). I could dig a bit more, if you could point me where to look for bugs=
 (After two days with SCSI subsystem, I didn\'t yet figured out all tho=
se interrelations between driver and common-code).
>
>Probably your best bet is to post to the scsi list
>(linux-scsi@vger.kernel.org) there may be someone there who actually
>uses this driver.
>
>James
>
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
