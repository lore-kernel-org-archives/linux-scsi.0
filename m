From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: Re: megaraid 2.00.3 driver question
Date: Wed, 30 Jul 2003 05:03:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F273587.2050009@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp12.eresmas.com ([62.81.235.112]:35984 "EHLO
	smtp12.eresmas.com") by vger.kernel.org with ESMTP id S272683AbTG3DDs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2003 23:03:48 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, apalma@custodium.com

=C1lvaro Palma wrote:

> I was browsing in LSI FTP site and find this:
>=20
> ftp://ftp.lsil.com/linux-megaraid/linux-2.4/megaraid-v2.00.3.tar.gz
> In what versions of the 2.4 kernel has been tested this driver? Why i=
s not=20
> public? I want to test 2.0 driver in a 2.4.20-19.7 kernel (RH 7.2) an=
d see if=20
> its performance is better than the standard 1.18f driver.

latest are at ftp://ftp.lsil.com/pub/linux-megaraid/drivers/
                                 ^^^

there are two trees. 1.1x, old and it was buggy, and the new 2.00.x
is a  redhat/dell/lsi... rewrite with latest hardware supported
and it's more "a linux driver".

you can get the 2.00.5 driver+patches in -ac kernel. And latest 1.18i a=
t the ftp

is there any chance to put 1.18i into .22-preX ?

regards,
--=20
Software is like sex, it's better when it's bug free.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
