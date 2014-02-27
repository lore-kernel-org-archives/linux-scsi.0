From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v12 1/4] PHY: Add function set_speed to generic PHY
 framework
Date: Thu, 27 Feb 2014 13:01:02 -0600
Message-ID: <20140227190102.GB4862@saruman.home>
References: <1393524848-8207-1-git-send-email-lho@apm.com>
 <1393524848-8207-2-git-send-email-lho@apm.com>
Reply-To: balbi@ti.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7239009573676957028=="
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1393524848-8207-2-git-send-email-lho@apm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Loc Ho <lho@apm.com>
Cc: devicetree@vger.kernel.org, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jcm@redhat.com, patches@apm.com, linux-kernel@vger.kernel.org, kishon@ti.com, olof@lixom.net, ddutile@redhat.com, tj@kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

--===============7239009573676957028==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline

--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Feb 27, 2014 at 11:14:05AM -0700, Loc Ho wrote:
> This patch adds function set_speed to the generic PHY framework operation
> structure. This function can be called to instruct the PHY underlying lay=
er
> at specified lane to configure for specified speed in hertz.

why ? looks like clk_set_rate() is your friend here. Can you be more
descriptive of the use case ? When will this be used ?

--=20
balbi

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTD4tuAAoJEIaOsuA1yqREAfUQAJcil86TUuxjq1TzHSeVz1wu
Q+SzrpfZ/A2I1VsAyOMsAclX1heGZ5hIbDMIQkkC/YDqEHJLa8cfkw9wYADES/e+
cTWysat7CROiWOgS4P7lCOz1OFEteI8kKFMe+eStwPtTH4nTSZKK6vT79p+p0oms
fruJJr9Cir4TzxACcvjPNYMRl34p71GelYYSzOOFXydv4EOpnPKdwCZk08hIPM3l
9UwlfHhT+HNO5yOsiOMUqf80yy0s6LPvVhBbak0Jlk1Dw11BPmOdHHseyeRmbNfZ
C/N1d9XsBYcvDCCoX06pxYx0U152K9yTA9QWZ9EUrZEwFsGcJgrPg0SvpD9VpYMi
0E5Ecbb/nPqEWeyjvEjFxfieyO35NJWp8mD6SWnhk0nz4YiiWNQxi5tZcfPbdr0J
//xgQo3F19Ft2nWeRPo6AVhEJJdM9e8ysGrR6WTd3lOSQNS6kxhJUfwFtbKLvXQa
PuYQJR1GM4ryv4vCrzAx5hFrs4sA+/J6l/eISK/A8wTFDn91/v55fsPBc9cRCW0Y
v34bMfgMG6QNGMX6bJRAkUlB9UkYXp4N05TfJubZTodC3PEPFlU/VjCvYMVdijTi
qpsflCF/tyY9LtBBqIGVyWm82XY5/iFXOECHUqyH5nVWe47MKMm5uJA/9iy9SnNg
q65W1BiddizQNtonWPJD
=/V1M
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--


--===============7239009573676957028==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--===============7239009573676957028==--
