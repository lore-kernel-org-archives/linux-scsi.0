From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] linux/types.h: Restore the ability to disable sparse
 endianness checks
Date: Mon, 23 Oct 2017 21:22:31 +0300
Message-ID: <20171023182231.GA16127@mtr-leonro.local>
References: <20171016172633.29290-1-bart.vanassche@wdc.com>
 <20171016224241-mutt-send-email-mst@kernel.org>
 <1508189195.2493.55.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1508189195.2493.55.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 16, 2017 at 09:26:36PM +0000, Bart Van Assche wrote:
> On Mon, 2017-10-16 at 22:57 +0300, Michael S. Tsirkin wrote:
> > On Mon, Oct 16, 2017 at 10:26:33AM -0700, Bart Van Assche wrote:

<...>

>
> > > Examples are drivers/scsi/qla2xxx and drivers/infiniband/hw/nes.
> >
> > These seem to be actively maintained. So post a patch, maintainers
> > can look at the spec to help make sure annotations are right.
>
> I don't have the time to delve deep in these two and the many other kernel
> drivers that are not endianness clean. So please stop telling *me* that *I*
> have to fix the endianness annotations in these drivers.

With all my respect, but authors of drivers/infiniband/hw/nes are not
showing any attempts to make that driver endianness clean. It works for them
and they have no worries about static analyzer tools output, so why Bart
should do it?

Thanks

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnuM2cACgkQ5GN7iDZy
WKd9RRAAjCkh9Ux2KBFZmp5vmDQ9e3GGE6bwWOIDEb3WFDwsXsMVTdQBMX4xB8f9
+2NH3LVr0is1wTYrW3xjlhcoCH9eqsKSB2xU8j3Uqc5U27STxHlQqSLh0/wQ5lH0
FoUUVLOiai99h3VhsME20LS/Wv3mr57YNte0evrVLTwx/Q44GI2S/3UcmnwXzjS2
YGwRAsVS1LtDnktZkxHZv1VjQ3cVpsCsI8Dv+MYuLLQ+eI7vfgyEVN9Y0x3K5wUC
Xcdsax//MdRq0QKyBO2DGmXxSgwV2SueTzNfi8jFJi8SKAGdK3T0Cnpll8foinAh
5gRvO+tPujojsfIajFxii5yXkQi+vma6b9IimR8lkLwy/4zTiWQ2a7YoTt4Q3sCE
3vNT6aWqAI5jvpUdFkgr9Y0/XGS9rxvomgeFGqASYskzOlt6WHbswM0+OylYhFJG
gMMiv9f+sI+d5OqMp7E/HT8h8bzy/uW9loE37ULrgzS93Bi7JKEqKO4edsuIPM3w
xgQ2qkjCpLYnfI7iDt8a6Gvm7ovkOc7v3gftF59/1quQsR0wB3yXRH/ZPGgSAl7k
3bf05/ymePg/T7WZfEwONW5MwYIBPQ9neUgp45qWH/30fxdv/kdryN8zK5u9pf60
4g2kMJEn8Jf1IRtlnCUriBpgjX2sSFU2/eRMfudo1W90t/NULDw=
=zmj1
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
