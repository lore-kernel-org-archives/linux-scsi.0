From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: sg driver and Fedora Core 2
Date: Sat, 29 May 2004 18:36:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040529163641.GG31365@devserv.devel.redhat.com>
References: <40B74725.90403@torque.net> <20040528172535.GD13961@devserv.devel.redhat.com> <1085846125.2101.29.camel@mulgrave> <20040529155744.GA32621@devserv.devel.redhat.com> <1085846840.2103.47.camel@mulgrave> <20040529162912.GA5922@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0lnxQi9hkpPO77W3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60626 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262574AbUE2Qgt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 12:36:49 -0400
Content-Disposition: inline
In-Reply-To: <20040529162912.GA5922@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--0lnxQi9hkpPO77W3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 29, 2004 at 12:29:12PM -0400, Alan Cox wrote:
> 
> Fedora bugzilla has demonstrated it *doesn't* work. 

yes cdrecord broke due to a bug in cdrecord and a somewhat discutable
behavior difference between SG_IO and /dev/sg when it comes to oversized IO
(which cdrecord issues as a result of it's own bug)

> There is a long list
> of broken third party apps such as drive firmware tools many of which will
> never include source code. The whole point of sg is arbitary management of
> devices. 

*AND SG_IO IS THAT*. You seem to ignore that consistently.
What changed is that you don't need top open some OTHER device to send
arbitrary commands to /dev/sda, but you can open /dev/sda directly to send
those commands, with the same ioctl. THAT changed. Don't tell me that very
long list of third party apps ALL doesn't take a device as argument....
undoubtedly several don't but... "long list"...

--0lnxQi9hkpPO77W3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAuLwZxULwo51rQBIRAnw8AJ4wYb/g3cx9EHsrjTB2ZFabAeCy0gCfR4H0
WCbHgbN+Jfl91OeOUp9+HJs=
=XO7d
-----END PGP SIGNATURE-----

--0lnxQi9hkpPO77W3--
