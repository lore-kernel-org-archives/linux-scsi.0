From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 4/5] Staging: hv: storvsc: Fix a bug in
 copy_from_bounce_buffer()
Date: Fri, 2 Dec 2011 00:11:48 +0300
Message-ID: <20111201211147.GL20466@mwanda>
References: <1322744315-13017-1-git-send-email-kys@microsoft.com>
 <1322744360-13067-1-git-send-email-kys@microsoft.com>
 <1322744360-13067-4-git-send-email-kys@microsoft.com>
 <20111201210304.GY3195@mwanda>
 <6E21E5352C11B742B20C142EB499E0481AA7B4EF@TK5EX14MBXC126.redmond.corp.microsoft.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lR6P3/j+HGelbRkf"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481AA7B4EF@TK5EX14MBXC126.redmond.corp.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "ohering@suse.com" <ohering@suse.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org


--lR6P3/j+HGelbRkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 01, 2011 at 09:07:46PM +0000, KY Srinivasan wrote:
> Sorry Dan. I put in some comments in the code describing the bug. Perhaps=
 I=20
> should have copied that in the changelog as well.

Yes.  That's the entire point of the changelog, in fact.  Could you
fix it and resend?

regards,
dan carpenter

--lR6P3/j+HGelbRkf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO1+2TAAoJEOnZkXI/YHqRd2AP/2+d0D0oDry5EazWZWRCDxRw
H/DtUbbV6Ci8A+tSwFTcJnLsU6o8/VOYbOfhnEG1h8trGyV3DlPa3UB/BaR1BRxA
ZP48/d2V3lUwPsc1e+JT0GafMsJm6ZAasGeJDoBKLphccy3sTT1JCR+W5DI9YyOq
NwNMFYPyU2mC6a4jDxX6ggNp57vveoCkTCdY4OE8R/ahS1QP42sIoaYFKWl63PFx
mxW394tgpF+8kZ1mxq/Ud4+UHvN0rdAYJfBPopRNU0QYdhKG35OFrYRwz+8RofiC
KVkax3yllVtphGJYUh/9gQMWHFWfEmePVmd/v7mkX5PtuRNkX+NSRLi+SVYuhjYA
lQkWcnOF1j0hLFtFU4v8IYyMhzxq1ay5NTAMM/biqWAvQxdee5EuAUsWtEU6b73t
6Kv4hui8HuCUYWkwgSxezFys+9EjmeHji88Y0GT2DF7VE/bCbBK0+jQbdM8Qgt75
yJuIFAY1kU+xlFPw2MX7qIEJxe6OT0WutXsF6h5GpRRSEd6V4Q5GKbvFosbSTG+m
BFUkhBxqpsoGZ3afH/6gOi788bIUNwtZealj2xQq5/x4JfenWIB+lOhKDVQ6LOU/
RfHnN9kDJSjtDTrjPLmCp2yapE62OK2G4gFjurF81u9FtM2Yewa2alBhIWH12Ou5
aeUOEKkO+gKAM3hjcCIK
=eHHN
-----END PGP SIGNATURE-----

--lR6P3/j+HGelbRkf--
