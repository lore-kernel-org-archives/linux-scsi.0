From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 10/13] IB/srp: use the new CQ API
Date: Mon, 14 Dec 2015 11:26:08 -0500
Message-ID: <566EEDA0.203@redhat.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-11-git-send-email-hch@lst.de>
 <5669C7AA.4080206@sandisk.com> <20151211142220.GB20201@lst.de>
 <566B0EE5.8080602@redhat.com> <20151212080833.GA32638@infradead.org>
 <566D47EC.3000000@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="woAFES8JS3ueHkgLljeVPGQsQPQbMDplG"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <566D47EC.3000000@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-rdma@vger.kernel.org, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--woAFES8JS3ueHkgLljeVPGQsQPQbMDplG
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/13/2015 05:26 AM, Sagi Grimberg wrote:
>=20
>> Allright.  How do you want to proceed?  The current rdma-cq branch
>> has all kinds of dependencies, but I've also prepared a new rdma-cq.2
>> branch that could go straight on top of your current queue:
>>
>> http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-c=
q.2
>>
>> If you're ready to start the 4.5 tree I can send those out as a patch
>> series.
>=20
> Will this get on top of iser-remote-inv? Or should I resend atop of thi=
s?

I'm going through my inbox right now.  I expect somewhere in there Or
will make his case for why he doesn't like Christoph's patch to get rid
of the attr struct.  I'll listen, and if I'm not convinced, I'll take
that patchset first and this one second. (I reviewed the patchset
already....aside from the fact that I *like* having the attr struct
elements in an organized sub-struct, it's fine and it definitely
improves on all of those query calls).

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--woAFES8JS3ueHkgLljeVPGQsQPQbMDplG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWbu2gAAoJELgmozMOVy/dWEkQAJgaW67D8ZAMdnP/02niP9K6
gmbpdwpxSShj7/oM5ZN9NtbxMDumoodsb1D+6CFxl7VxANtj3QGjA13bCSbZR0Zk
9U/JOJ0HJI75R02pz/G6d7wePVNEU00Vwuc1/eGkNyPwWMHWjzjbF3bJSxklBYdN
kTOZF/o2dneGLAXKEp5OYyTPc1HVd5raHSPJ1pNSWTFMLE4PQSIjY9uoBir4LdDO
TtINjsM9Izwlr53JeWqXd1t+UDThMSQxW7d44ANu/NEFAjJ7hjj1xOfH3v28ENV7
pBp5hmfwTNhegRzt67XbOPdvce+KSEbdwGeWpp97GKjAc41BGQVDSBRNdRL5oK5K
7M3fwZCxtYwIfOYt5d3ZqzySZoIGxr6NKxtHrNAyXewHzhhveKdxcUEJ+MbDgQeF
J9bJucUo+QTlp44Ebui2XfabUR6KAcn9ZfmVsvRke9u6ciWUz5+xAhJ5cCRCCvwW
pZbqK0+1OCKvus2lPMmuL56i7xt5fYikGrHgSpDHmZz3jZYvUBAMHbKW04aiB7h9
vAJksxNOaSq8OCGj4WED5ZdDJJ2lf4JBiQDq2QmfF0Ylcb8HjdC44uaCaTuxrI1L
VVMh0cdc5n1Ys0Jq0RNSMIHxcjrAjXrOQ4lW0S2SQr7af4+qZ6eT9wEgQwJ6r+ZP
VfMLHb1rrvAgBmJf4nbb
=anU5
-----END PGP SIGNATURE-----

--woAFES8JS3ueHkgLljeVPGQsQPQbMDplG--
