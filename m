From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH-v2 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Wed, 11 Jun 2014 01:47:30 +1000
Message-ID: <20140611014730.7f3f2e60@canb.auug.org.au>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com>
	<20140609133026.GA6239@redhat.com>
	<1402383912.5774.13.camel@haakon3.risingtidesystems.com>
	<20140610094254.GC7423@redhat.com>
	<20140610215217.495d5476@canb.auug.org.au>
	<20140610130208.GA27702@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/524xNDlSYz=Gl6BhkuEmfW8"; protocol="application/pgp-signature"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140610130208.GA27702@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-scsi@vger.kernel.org

--Sig_/524xNDlSYz=Gl6BhkuEmfW8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Michael,

On Tue, 10 Jun 2014 16:02:08 +0300 "Michael S. Tsirkin" <mst@redhat.com> wr=
ote:
>
> I don't see how that's possible.
> Here's a point you might have missed.
> Nicholas's patch isn't just introducing a merge conflict.
> It is also buggy.

Ah ha!  Indeed that is a different kettle of fish. :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/524xNDlSYz=Gl6BhkuEmfW8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTlyiZAAoJEMDTa8Ir7ZwVxIsQAIn7Tbtr8SAJlv2YILJG4XHK
p4fi4UQE5W2qr+eXkuhdZGvBjxuv+XkRJdagOSXvYTch7HsziJfCoMFEtDHtcs+c
agsDeHcXzAEXVFSmeDMlPzSgpqfehafGrkNkhvvhdnzrhbs9esUoi4FJZ6Z4u30+
Of2HR48S2gEKEZgI9k3exVcEF+gWxAYcPTCHFa+QRjEuL6B1udVLwNYamFRlVRev
XIIxNmisvGQWTFupplT3rFwZhjlY+/8H708+q+RdcIkD9eJInBrKRWDrzgQOvb+N
0AocnCMq2NABualuVNRtgQmz1eVTt7LqZHabX8PaNMELvAqNRok8scHmZ6cB/f7f
XQ6+MLfqz+zg3xdhoKK5pHErSTz9Q9tj/dCFHWYmiWvbFi0fKWzmvtUZLVN2wOLp
nT3aL3wqUKvWytVs8Oxek8xiLjKAmH7afAoZbYKyi628x56Meyk5ZABOMJEXUXUX
iUXEJdKQzfO1SFPkkwBgU3v7EXLmqKWwIg1WFmDy3bc8RxBYdNvPu+08TY6n1nhH
RPOMGkpUCsx1WSETin0YcW+0J3WV21Aafmt3cluCSMICThXUid2iucdVXX6MpqDj
WTx1LOAwusu+uYDn8LsXCNyl/F9mu67eF4sNynkrZFQlxN0sVLUtNdfIko5Faqj6
9RTyrNoP8nV4QF0mLrC2
=zGKe
-----END PGP SIGNATURE-----

--Sig_/524xNDlSYz=Gl6BhkuEmfW8--
