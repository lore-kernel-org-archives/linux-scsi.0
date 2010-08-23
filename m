From: Sergey Vlasov <vsu@altlinux.ru>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace
 barrier with sequenced flush
Date: Mon, 23 Aug 2010 20:45:22 +0400
Message-ID: <20100823164522.GA9528@atlas.home>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
	<20100820132214.GA6184@lst.de> <4C6E9CAF.5010202@redhat.com>
	<4C7269E9.9070304@kernel.org> <20100823124815.GA20095@lst.de>
	<4C727E96.5020801@redhat.com> <4C727F2B.6060501@fusionio.com>
	<4C729171.3030605@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5913051511334986110=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4C729171.3030605@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ric Wheeler <rwheeler@redhat.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>, "vst@vlnb.net" <vst@vlnb.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "konishi.ryusuke@lab.ntt.co.jp" <konishi.ryusuke@lab.ntt.co.jp>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>, "swhiteho@redhat.com" <swhiteho@redhat.com>, "chris.mason@oracle.com" <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org


--===============5913051511334986110==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 23, 2010 at 11:19:13AM -0400, Ric Wheeler wrote:
[...]
> (2) hardware raid cards with internal buffer memory and on-card battery b=
ackup=20
> (they sit in your server, disks sit in jbod like expansion shelves). Thes=
e are=20
> fine if the drives in those shelves have write cache disabled.

Actually some of such cards keep write cache on the drives enabled and
issue FLUSH CACHE commands to the drives.  E.g., 3ware 9690SA behaves
like this at least with SATA drives (the FLUSH CACHE commands can be
seen after enabling performance monitoring - they often end up in the
"10 commands having the largest latency" table).  This can actually be
safe if the card waits for the FLUSH CACHE completion before making
the write cache data in its battery-backed memory available for reuse
(and the drive implements the FLUSH CACHE command correctly).

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxypaIACgkQW82GfkQfsqI94QCeLiRSclQhAVlFnmFnK49Fh41s
55EAn1CXk2dhHSW/+tvscDZYwHy5ZG37
=v7Fn
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--


--===============5913051511334986110==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5913051511334986110==--
