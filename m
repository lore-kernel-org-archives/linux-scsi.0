From: =?UTF-8?B?QW5kcsOpLVNlYmFzdGlhbiBMaWViZQ==?= <andre@lianse.eu>
Subject: Re: [PATCH] mpt2sas: New feature - Fast Load Support
Date: Tue, 10 Jan 2012 09:48:29 +0100
Message-ID: <4F0BFB5D.6030802@lianse.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40948 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2AJIse (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2012 03:48:34 -0500
Received: by eekc41 with SMTP id c41so104318eek.19
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2012 00:48:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi guys,

I've run into problems with the all new shiny 3.2 kernel. My system
broke badly as it's depending on some devices which are attached to my
LSI SAS 2008 hba.
The mount scripts of my gentoo/openrc setup get triggered right after
udev has settled.  But with the new fast load support udev settles
before my drives appear to the system, so mount fails for all those
drives and of cause all subsequent services depending on them.
Is there any switch to revert back to the old behavior of blocking unti=
l
all ports scans are done?

Thanks in advance
Andr=C3=A9-Sebastian Liebe

- --=20
gpg key AA1E1F66 @ gpg-keyserver.de: Andr=C3=A9-Sebastian Liebe <andre@=
lianse.eu>
Key fingerprint =3D 5436 5358 172C EB7D E414  C6DE 6664 89BF AA1E 1F66
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPC/tXAAoJEIvQ0TmZSz9R+ywP/Ays9LD9+UgfrmU/U5mc2HxA
n9QcZUK6CNGdw6QA8XsLKXPIOZYsCBiiLroNORzFfwRW7xsue1YMD6tR121TjmYL
QA9C9Clf9WYJT8RTEkmECHkejvxAkBqu0FhMJJC3377L2/qAN2NSkz6VInzqAdqE
My4948xRx0z7ysjiFqRwOeZgss70IowshwDO5mAbuAawOQZa3UZo72HZ8gVxbf4H
xKhPLy6QraEJX3SMtTmJDvp46xJ5UN4yXosdOD7pkYUeCnTX7AhaO+bIuEPgGB9Q
UaEawMoMq8cPVEXl4L5gvPkIKCWdnmCLTtDcOeqTxuHoyOx/qn8xvh2D4K2shWgf
jaxPN9VGa6VBIxmZWjX4emtI2QqhjnaW8o7A+hz1K8rJO1SgCdGJxdB+gjLhXcLe
ZYKLOJ5OFIX8JQk6IjUTLkRCnZpEG/WORU+fSU93dCglcRxnevPUvIs3rpTzstGd
/DKN5JPXMIPvX3aJ5sWoXygpnq9oOfPAMDXB4jibkYbbnF4aqWEp7m+l7g84dH0N
2O0SFQm7VTb15Pp3ZIKGQhxfVxHwsd+fnoM1rpqkRRrF4YmovuFgsHr7qjE4astq
/c9TUJzn/93fan/f0FrW9KlBE26zqwCp6HIbNe/HLSZgdMXGVWynwa3w86d17eyg
givRtuynhgPB/KDyoavm
=3D5BNV
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
