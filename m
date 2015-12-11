From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 10/13] IB/srp: use the new CQ API
Date: Fri, 11 Dec 2015 12:59:01 -0500
Message-ID: <566B0EE5.8080602@redhat.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-11-git-send-email-hch@lst.de>
 <5669C7AA.4080206@sandisk.com> <20151211142220.GB20201@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BvR88TPtErBIle0CjlApI2jFpQJ0lJiXT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151211142220.GB20201-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BvR88TPtErBIle0CjlApI2jFpQJ0lJiXT
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/11/2015 09:22 AM, Christoph Hellwig wrote:
> Hi Bart,
>=20
> thanks for all the reviews.  I've updated the git branch with your
> suggestions and reviewed-by tags.  I'm going to wait a little bit
> longer for other reviews to come in before reposting the series.

Indeed, thanks for all the catches Bart.  This patchset, with Bart's
fixups, looks good to me.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--BvR88TPtErBIle0CjlApI2jFpQJ0lJiXT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWaw7lAAoJELgmozMOVy/duWoP/1qnRIS+5tCt4MTDCoRVUBdJ
sJavLsDaFBs75RggOTERaD3x0fFpduP3yLba+PGEmn6lGyxdXJOnsabCRd9yEGU1
nsZXaG1OJdNc2E+9ECWR3wR3tLUnZTLa4e8M6ckDwkO/IxL1xkOdMujdwAnh0cib
DCPw8282mySkyNad8g6KLO0MR7IElDpTSg3qi111chTMATh3jcaCQHdfQxlnHyMa
dAGp0fG4L6ATbRuDjn84iJCqBi62WayKfspvDOLSbmFRFsAWXn1cN3hYBCYyjEB6
VL9TyS+xcgampIMPLe1AUHki3/M2/Ps5oUZ1UV8MBrfGyv/YwMnbdxV4qPSUP5Pl
rKyiQwkgMEoUUQem9JaS6+lgIO+Uvt7/P/oIsBUlf1ERbFicYsEVWAt3GRWRSjSw
q8jqwEFL0cJDZhriW7p/dvAvKGJt8LQR0Vqk0wqYsDpooJCo1jsUuSkfPna9AoLn
sBIZhz82t4lSTvdmzd5wwQdgRir00rdWm6CeCPMBh2cTUDJXK+YAHmf7Lwz5e/6u
iNqkPWLXUe8kjcwqQVzn4i2jGfGTX6rIxi+epVrvj0CbqYjCqBuZ7utHcLBrU63u
3aXUcA1+XuCkRcGEG7WryiesfwdUqe/jwAAWkfX9EWwROLySEL+rrACVWgKcyznF
qjv2p+LlRs5Dj4+AAT47
=QWoB
-----END PGP SIGNATURE-----

--BvR88TPtErBIle0CjlApI2jFpQJ0lJiXT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
