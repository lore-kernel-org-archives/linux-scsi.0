From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v12 1/4] PHY: Add function set_speed to generic PHY
 framework
Date: Thu, 27 Feb 2014 14:50:39 -0600
Message-ID: <20140227205039.GE5375@saruman.home>
References: <1393524848-8207-1-git-send-email-lho@apm.com>
 <1393524848-8207-2-git-send-email-lho@apm.com>
 <20140227190102.GB4862@saruman.home>
 <CAPw-ZT=F07=T0=z=iT=hxJ0+609RBDYRL=MXF5dQoEowLjsRjQ@mail.gmail.com>
Reply-To: <balbi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lteA1dqeVaWQ9QQl"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPw-ZT=F07=T0=z=iT=hxJ0+609RBDYRL=MXF5dQoEowLjsRjQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: balbi@ti.com, Kishon Vijay Abraham I <kishon@ti.com>, Tejun Heo <tj@kernel.org>, Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>
List-Id: linux-scsi@vger.kernel.org

--lteA1dqeVaWQ9QQl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Feb 27, 2014 at 11:57:44AM -0800, Loc Ho wrote:
> > On Thu, Feb 27, 2014 at 11:14:05AM -0700, Loc Ho wrote:
> >> This patch adds function set_speed to the generic PHY framework operat=
ion
> >> structure. This function can be called to instruct the PHY underlying =
layer
> >> at specified lane to configure for specified speed in hertz.
> >
> > why ? looks like clk_set_rate() is your friend here. Can you be more
> > descriptive of the use case ? When will this be used ?
> >
>=20
> The phy_set_speed is used to configure the operation speed of the PHY
> at run-time. The clock interface in general is used to configure the
> clock input to the IP. I don't believe they are the same thing. Maybe
> it will be clear in my response to your second email

The problem with this is that you end up adding SATA-specific details to
something which is supposed to be generic. After negoatiation, don't you
get any interrupt from your PHY indicating that link speed negotiation
is done ? Or is that IRQ only on AHCI IP ?


cheers

--=20
balbi

--lteA1dqeVaWQ9QQl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTD6UfAAoJEIaOsuA1yqRERr8P/iDeKDJi1ZMvKmvSImZ0pI/Q
lrufRgik17xRfpmkp/qfyWJZxVsBy8I995h13ZapXWaW/HpyrBsEASsXFEC1d+r7
aZpmcVJgGcSIqzUZiSS2nZEqRjch2P+NVLy7IO4aJAYcQoX1GqTHXXDq3an7iY0G
2BX7ycz1ApTaiOaMxYSNdr9t6j5KytDCFXvKdwzC9Q0AjAeWAZUefA6nIuoRzA3t
qc7Yi6U9IW2RYkzuY3RkkHko1DoQReAKajQ6hpmxMX5tG8oqjkP67ZUt0HYDuwJt
K3DfduE1MeQPygnyrX+IfGt7lEkgpqHxcC+9i5FmsqA738kPWMa5yY0olNxtgjkE
wDDpmKcXDQX8tGF7ku6z5hhaOuLMHpiwh4eMLf0nbbSejWmrYu4AcwYj3zlayFvx
djzJxXTDVYauiYNv4HLENb/ZpqKVfdi9fx+pJtYB1yiIWrtCNl/5ikumUSoIPdj+
6z0XnY6hCah7rZDsFCTclNFP48zNy3znUR701lyf1ApraDKfH4qmAtY0ifwB474v
+2vXwOD598uPRF4urjF6bj3AgOQAlZ6ThAIsrbo46MBjTWbWYJstO+RzA3T3FDa6
7ghCqLbHi0fDeUEOZ/o6ScPD5bXvpMwvQoCQ1OXbeoLzKja6BPljaUUKlxCuYlRP
PeQ5ZAkBoaIVwd+jDb46
=qKot
-----END PGP SIGNATURE-----

--lteA1dqeVaWQ9QQl--
