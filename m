From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Mon, 3 Feb 2014 16:26:48 -0600
Message-ID: <52F017A8.8010204@tributary.com>
References: <1391157974-17512-1-git-send-email-hare@suse.de> <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de> <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi> <52EE2F2D.1010300@suse.de> <52EFACA4.6060001@tributary.com> <52EFB06C.8010101@suse.de> <52EFB0E7.3000504@tributary.com> <CAPXgP13dn+VGpu0OLHatUvP4TRDp2YEgCXYB837ReADZTWg_NA@mail.gmail.com> <52F010F9.5090305@tributary.com> <CAPXgP13yiD3Fk7NpgRqac5vj=OVuav=P1LXLp4Lty9G2ws9pnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.55]:33913 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaBCW0v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2014 17:26:51 -0500
In-Reply-To: <CAPXgP13yiD3Fk7NpgRqac5vj=OVuav=P1LXLp4Lty9G2ws9pnQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay@vrfy.org>
Cc: Hannes Reinecke <hare@suse.de>, =?UTF-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVt?= =?UTF-8?B?YnVzKSI=?= <kai.makisara@kolumbus.fi>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/3/2014 4:15 PM, Kay Sievers wrote:
> got through quite a few changes over the years. Not sure how much the 
> /dev/tape/by-*/ links are really used in the field, and what people really
> expect here.
	I'm not sure they actually work that much either (random opensuse 12.3 machine).

lrwxrwxrwx 1 root root  9 Feb  3 15:31 /dev/tape/by-id/scsi-3201034d7b4000007
- -> ../../st3
lrwxrwxrwx 1 root root 10 Feb  3 15:31
/dev/tape/by-id/scsi-3201034d7b4000007-nst -> ../../nst1

That is what shows up on my machine with 4 tape drives /dev/st0->st4. Its
because there are 4 devices with the same I_T and different luns. The /dev/st*
and /dev/nst* are correct.





> Sure, but do they really expect the additional symlinks udev creates? We
> are not talking about the primary device nodes, only about the additional
> /dev/tape/by-*/ links.

	Oh... I suspect your right. If anyone is using it is probably one off scripts.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS8BeoAAoJEL5i86xrzcy7wBkH/jn9wewZIU7DrVRLc0OiHTDh
Cm7Fo4wir01i8t29P+qL3EgsMzoe7w3xfCJ74rRks5UO5Vl13NmI0ck3rJ+ElTf7
9MJl40cgQgYB+ATCMy91mcObr6KTwkRI1n1oZZKV8YAd20mGSDIEv9FeqHGEWOC4
c3THh+6C0Fb63cYQ6X3oyK8twHNJl8HAJPRbnZ0oKdvSFdoAGBXoBxQ7mbsaWBcI
HkTF6ArHdIMGMeI4F1PUROKMsSeEhwzudvJY3+fb7pQO3pmG6aFTCTVlkSZiDVNX
uqhbB9cdz6c0GYHVg/3jCEsmdzMmlT/qY0jy6NChBPgdFpsS1CAfbnYW2eKtpS4=
=ANj0
-----END PGP SIGNATURE-----
