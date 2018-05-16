From: Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: Re: [PATCH 1/2] Convert target drivers to use sbitmap
Date: Wed, 16 May 2018 08:54:31 +0300
Message-ID: <8736ys9mco.fsf@linux.intel.com>
References: <20180515160043.27044-1-willy@infradead.org> <20180515160043.27044-2-willy@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180515160043.27044-2-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-usb@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, Juergen Gross <jgross@suse.com>, qla2xxx-upstream@qlogic.com, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Matthew Wilcox <willy@infradead.org> writes:
> From: Matthew Wilcox <mawilcox@microsoft.com>
>
> The sbitmap and the percpu_ida perform essentially the same task,
> allocating tags for commands.  Since the sbitmap is more used than
> the percpu_ida, convert the percpu_ida users to the sbitmap API.
>
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
> ---

[...]

>  drivers/usb/gadget/function/f_tcm.c      |  8 +++---

for drivers/usb/gadget/function/f_tcm.c

Acked-by: Felipe Balbi <felipe.balbi@linux.intel.com>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAlr7x5kACgkQzL64meEa
mQZTNw/7BeARv5AHTU76jM8Zj2RGQnhmwK+vPHpdEEIiwl+eENFkYn8HCpxz6Fy/
8+ZLFWGD2OSNpenF/oHeMyuLjbD1nbeYk95GU3zXJbeTQp7Cl5m5j05mcAqziWD6
I+EExa95spRapO1A03KDnDsOgCe9nVM+j2BT/nXvUiSmyT3Z80XcuextwlpFCh0t
Lzw+k9HT8LfdgFKIY4d8fXBakn/Ezuvcm1thYlLJNACjePusCvo8Fv4R3jVTsmFJ
OdsgkEIPhHUJnyg13fAWatJU77mzxhH1wu+3gAUv5UuhAu7QEvLTlOMYRc/Jp5JG
U+y/wxeoY1VgmFlZDHPcm/W8wGGlM5Lv2KqPuwBjxErHxJ0Mzf4/MFatLj3g+QOK
pzmlRNpl+36e5+kifuQhZk+YiqgOwQIs96HmZlwCZy0E1IfZYY8d1mFky0aocqbG
Mi096aKi4JIhXJ/cbi4bWlq26P/LQdYQYa83WfZQN0pHKVdaI1baUbtU3EFqt1PV
/asEEy8d0bt4HD3kutz3Kv2wqKbKP4i3aR8voXhI9Er09EXjxtL6mM2y3z4jhYDa
SocWSQ88Y+vNhWWtZXOTKK1/lonuPjIdR8Xb4BOaWnJgb/XXNaj7nioloxjxA8It
sDGjUAaySMhhC2Ga2WcrkXOJRmbVL5lyBi9nJWm7viDHOJIfZLI=
=DXbr
-----END PGP SIGNATURE-----
--=-=-=--
