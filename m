From: Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH v2 00/21] Allow compile-testing NO_DMA (drivers)
Date: Tue, 20 Mar 2018 11:02:50 +0100
Message-ID: <20180320100250.ggt3rgjnk6g3fkww@katana>
References: <1521208314-4783-1-git-send-email-geert@linux-m68k.org>
 <20180316212317.7d5rri3p25hpmx44@ninjato>
 <CAMuHMdUUKMngcyajm_s==KbhL3ZjMNHVxhNNGkPWkpnePE2rMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7166034885768521521=="
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <CAMuHMdUUKMngcyajm_s==KbhL3ZjMNHVxhNNGkPWkpnePE2rMw@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, linux-iio@vger.kernel.org, linux-fpga@vger.kernel.org, linux-remoteproc@vger.kernel.org, ALSA Development Mailing List <alsa-devel@alsa-project.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Eric Anholt <eric@anholt.net>, netdev <netdev@vger.kernel.org>, MTD Maling List <linux-mtd@lists.infradead.org>, Linux I2C <linux-i2c@vger.kernel.org>, linux1394-devel@lists.sourceforge.net, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Stefan Wahren <stefan.wahren@i2se.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Herbert Xu <herbert@gondor.apana.org.au>, scsi <linux-scsi@vger.kernel.org>, Richard Weinberger <richard@nod.at>, Joerg Roedel <joro@8bytes.org>, Jassi Brar <jassisinghbrar@gmail.com>, Marek Vasut <marek.vasut@gmail.com>, linux-seria
List-Id: linux-scsi@vger.kernel.org


--===============7166034885768521521==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="kswnoihqyjs4firo"
Content-Disposition: inline


--kswnoihqyjs4firo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> To play it safe, you want to postpone the subsystem patches until the core
> part has landed upstream. I will rebase and resubmit after v4.17-rc1.

Thanks for the heads up. I'll wait for the rebased patch then and apply
it after rc1 for 4.17.


--kswnoihqyjs4firo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlqw3EYACgkQFA3kzBSg
KbY6yQ/+ImBXoqOKYU53q1YyxSyYsjKkmkSg9TnYq3KS9/78H+7QE/YI3e/rQ0gu
DrG+4EwDjMTyQwNAOljF9krnn2l1R+2F71yAqNF1g95sZOGW28bT2Ih6K49/61Pv
8p8VUetCMUs7oTCmhqnDL6UQbx9JhuRK4VSp4EL8K/8p93QuD9bD7yRbe2Sf2+bt
430CEgTK0lybqXIFj+mAZ4Jcjc3y4MgUsH+2stSCSDnMozmnFjrF1IVRU1zaj8pU
NG4F2Lx6eHtHl6pyi0TOoCCJRSGZo3kjYw62FfJUKhLUpM6Z8kEhZc48QjEkQlJp
t7Do9GunImlFpmN/72crKecesNnZW9MlHA8wLfTfDiNiVzZDIOi+jCfTNQboSpWe
PBpEupOaWoqPJjIa36mggu02UrxE2nqw0HlXFFRsBcDYllIB7xf2Vid45kd4gj+T
wytNrwtv5wyZtwnb4yFguwNeq6vPH/xnc/8Agl7qQnMh+VYAGMkJ0oV8/oOAawH3
9XBh3Gp9+nA7htdffgS6DoWfVx5Jg87aMNlWo3Fgza20+Kh8Cn0RAECez7LfGaNL
mvqQKVwFgnjXKkCdJZn2jaQKnb6Wlh9QD1Vg8ZJ7V5Osj/+tMxM7xJTqzox4Ik/5
cqckgKDiQYQWDkcpEShwK4sTAcaneaZ/pen19XnefXGwqlBKhDM=
=JhkV
-----END PGP SIGNATURE-----

--kswnoihqyjs4firo--


--===============7166034885768521521==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/

--===============7166034885768521521==--
