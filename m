From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: iSCSI device naming issues
Date: Sun, 04 Jul 2004 21:57:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1088971063.2736.10.camel@laptop.fenrus.com>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAAXdSfMOoTnU6X86O4sbqWzAEAAAAA@cisco.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DbLWfrid1K9dEYaNLJp4"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:3293 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265773AbUGDT5x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jul 2004 15:57:53 -0400
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAAXdSfMOoTnU6X86O4sbqWzAEAAAAA@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>
Cc: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>


--=-DbLWfrid1K9dEYaNLJp4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2004-07-01 at 15:58, Surekha.PC wrote:
> Whenever an iSCSI device is configured in the system, a hotplug
> event is generated which invokes udev for device node creation.
> iSCSI driver has a CALLOUT rule for udev to generate a unique
> name for iSCSI devices.

wouldn't this all be a lot cleaner if you follow the
one-hba-per-remote-host model ?

--=-DbLWfrid1K9dEYaNLJp4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBA6GE3xULwo51rQBIRAl5hAJ4h8qypKonYgsRph8SN/RWNmg/GgQCeKxXT
/RAv9pay6cazo9zqZKAjHNc=
=olu4
-----END PGP SIGNATURE-----

--=-DbLWfrid1K9dEYaNLJp4--

