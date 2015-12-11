From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH 3/6] cxlflash: Updated date of the driver
Date: Fri, 11 Dec 2015 11:35:50 +1100
Message-ID: <87d1udkejd.fsf@gamma.ozlabs.ibm.com>
References: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com> <1449788043-23131-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34600 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbbLKAgG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2015 19:36:06 -0500
Received: by pacwq6 with SMTP id wq6so55565468pac.1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2015 16:36:04 -0800 (PST)
In-Reply-To: <1449788043-23131-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>

--=-=-=
Content-Type: text/plain

Hi Uma,

It looks like CXLFLASH_DRIVER_DATE is only used once, on init, and it's
just printed. Is it necessary? It looks like having it will require
sending a patch to update it quite often.

Regards,
Daniel


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJWahpmAAoJEPC3R3P2I92FSigQAJseIBcAEP73RbpOzdj/PJDe
zYoI/hKZI/hrQhw0i44r/VeVFsVW8WxPq4oCjuer2CiNZ4T6HPSVNVL9UIUXm/LX
DeO6oRdYV+S9ccKiVmWcw5A3POUuDNK5E0Nsd1+mUjZ3ZMIUaFCxZviKSuzfgrpt
RIlmjz+pxX+BhRD2jkydHhMFwfndQ60jAlZooV3NI3OU7XBrFogfSVgRqISK7U2g
PtmU1K632tKworo6Vk0Y885mjvi2o0KxdhMN66z2c43CzOwIh15FIfUUjozqiTxD
8anDt880vn/CsUzgatVa1jC3D9SUrrRvJ9iZFM6wZMV7TaBkNNYXtgZ7Z3rQ0mBP
nn/gxdEEUi+EidZPkP4EEjv7drrLKnVzJOig/sSw7UcFE3ZFhvVhWIYio9kXNKoe
PzfwRzOKRt/MtPY4GSbl0SDHTdPzcf0XOAqjG2uguCo7rQAa1At7oI0de7mp2wHQ
k5j9gIRRuKA/7I236s2OAwIS8Ntj71Q6fy8hFem41G2wWtgNsEHBCGxGq3s+iG1l
nCainAaft41JkCK++fhHvLazpBxDXO4+jhWZrrmTbm+8YcnOwKz6MSsa4oF1Heyu
R1k578PSdH6hOYezJM8+s0ri7XO59reUWjIHS8xEk0oiE3xAeUTxSwdZvHUVLUCa
FL9BhChbWeg0xhxD3LA+
=puNN
-----END PGP SIGNATURE-----
--=-=-=--
