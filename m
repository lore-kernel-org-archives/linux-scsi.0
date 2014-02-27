From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v12 3/4] PHY: add APM X-Gene SoC 15Gbps Multi-purpose PHY
 driver
Date: Thu, 27 Feb 2014 13:02:59 -0600
Message-ID: <20140227190259.GC4862@saruman.home>
References: <1393524848-8207-1-git-send-email-lho@apm.com>
 <1393524848-8207-2-git-send-email-lho@apm.com>
 <1393524848-8207-3-git-send-email-lho@apm.com>
 <1393524848-8207-4-git-send-email-lho@apm.com>
Reply-To: balbi@ti.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5909222516763479711=="
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1393524848-8207-4-git-send-email-lho@apm.com>
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
Cc: devicetree@vger.kernel.org, Suman Tripathi <stripathi@apm.com>, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jcm@redhat.com, patches@apm.com, linux-kernel@vger.kernel.org, kishon@ti.com, olof@lixom.net, ddutile@redhat.com, tj@kernel.org, Tuan Phan <tphan@apm.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

--===============5909222516763479711==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Content-Disposition: inline

--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Feb 27, 2014 at 11:14:07AM -0700, Loc Ho wrote:
> +/*
> + * This function is used to configure the PHY to operation as either SAT=
A Gen1
> + * or Gen2 speed.
> + */
> +static void xgene_phy_sata_force_gen(struct xgene_phy_ctx *ctx,
> +				     int lane, int gen)

why do you need to *force* the generation ? Is this because of some
silicon errata ? It almost seems like this should be done through link
negotiation between both link partners.

--=20
balbi

--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTD4vjAAoJEIaOsuA1yqREcU8P/3ZS9KNms08cXSMj1uAFPNFh
3CPHf7MFJI0kwNaeSIvsvsMf9FelziGBtxsXKTTBKgKv0LmyaNcz6XHj8F/GtAdE
hX6vjyB4ktxBFyU8VbeOkJqqddtVudEC/ZFl6iXxcVL6Jg3N1gEH/j8W4hosqyJU
STMaV0Hj7hp1pOrYeMCjvRgHEkkAY3q9xqnJp1+4/9Js7wXpvt/YSPKjRJ303k0N
dlCLy0vPNZiAaWZogdx+MvrJtpY3aOxKBHqSKTHmClaSrNlJVDUyHE6IT7ViigLM
Nck5qYS3T2OLuZbirGGHmMtk/cLWIDCoGaRRkp8XrNX9/6oJBhjPdqvEbJDRzbko
MqavfzzvhNXElWdxaVaWW0Hj51Fb+5k+kYuYoPOMNufDovpvjaFlzs7TJLcTkHy2
qUHjz6qjQQ7rWKb0ITw4oZU+3vSfFsDKHAe+XXzuG+gF+0Rs+4C0ZxcDiHPgJXgE
qLXt0vyX32Nd3h8ghb3UdstwWH7IYLjMna4vZ6rGy05SyOAPNHjZpPAL3QVHCTOB
sGV0JGBx7cE+uFqr1xmpCVyYAa9RDFOT3n2ZyFUWI5HIcWkehjEzDwcwgaYn+Vl1
xlr4IYmq4SMhSpREsaYalyxUximCSP9k8bUqFT1Oo/DxXqVOihcIX8ji8+0FM/M7
DHMC4kpgLzarods/i/RK
=cHF/
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--


--===============5909222516763479711==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--===============5909222516763479711==--
