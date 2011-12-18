From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] scsi_dh: Fix return value of scsi_dh_attach()
Date: Sun, 18 Dec 2011 15:53:02 +0100
Message-ID: <4EEDFE4E.6090104@nod.at>
References: <1321572864-23628-1-git-send-email-richard@nod.at>  <4EEDFC16.90303@nod.at> <1324219540.3091.28.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig60DEDFA65EC78D6EB03FC35D"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:34923 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab1LROxF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Dec 2011 09:53:05 -0500
In-Reply-To: <1324219540.3091.28.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig60DEDFA65EC78D6EB03FC35D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 18.12.2011 15:45, schrieb James Bottomley:
> On Sun, 2011-12-18 at 15:43 +0100, Richard Weinberger wrote:
>> Am 18.11.2011 00:34, schrieb Richard Weinberger:
>>> scsi_dh_attach() should return a negative value on error.
>>>
>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>> ---
>>>  include/scsi/scsi_dh.h |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
>>> index e3f2db2..e07ab10 100644
>>> --- a/include/scsi/scsi_dh.h
>>> +++ b/include/scsi/scsi_dh.h
>>> @@ -74,7 +74,7 @@ static inline int scsi_dh_handler_exist(const char =
*name)
>>>  }
>>>  static inline int scsi_dh_attach(struct request_queue *req, const ch=
ar *name)
>>>  {
>>> -	return SCSI_DH_NOSYS;
>>> +	return -SCSI_DH_NOSYS;
>>>  }
>>>  static inline void scsi_dh_detach(struct request_queue *q)
>>>  {
>>
>> James,
>>
>> can you please pickup this patch?
>=20
> It still needs an ack from rdac people (other one just got overlooked).=

>=20

Who are the rdac people?
I sent the patch to all addresses reported by get_maintainers.pl.

Thanks,
//richard


--------------enig60DEDFA65EC78D6EB03FC35D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJO7f5PAAoJEN9758yqZn9e6gsIANAV834jgwFjKiWSGmXHWFHu
eSMHIrMmLVzvu73poG2iNUKEA1hZGya3JYlvkIZSm9RduJ/ebDlO95ryWwZKlkbL
D+rKI729C2JCZSWgDV8RGQPUdUCfFVUeMjJw7k8Sg4iXwhtr9DgNuTfYmxx58cVi
/ft7RSIXDdYXAoZ7sPzgIaATng5Z0tMbP6bMnHyuaL9Odbkty0+woC5O9n40cn+7
fvggefh2raD5ApxqpPQKI0FGjl4pbN4U6tryil7nVpRMRGb/dbkOgjUaerNpRqS2
bx2dGA4xRl4Tdope3hWy5yQjgMhgHdHMKN4kdpLlOzw2kw8wUiiJ1uuVPQ8+YC4=
=E8Lj
-----END PGP SIGNATURE-----

--------------enig60DEDFA65EC78D6EB03FC35D--
