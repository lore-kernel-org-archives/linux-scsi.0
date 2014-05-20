From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ANNOUNCE] scsi patch queue tree
Date: Wed, 21 May 2014 09:46:36 +1000
Message-ID: <20140521094636.515289e8@canb.auug.org.au>
References: <20140519140614.GA12183@infradead.org>
	<20140520100343.31490551@canb.auug.org.au>
	<20140520053928.GA1751@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/BLXwGnY2=g.BoJG1vfX9+Rw"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140520053928.GA1751@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Sig_/BLXwGnY2=g.BoJG1vfX9+Rw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Mon, 19 May 2014 22:39:28 -0700 Christoph Hellwig <hch@infradead.org> wr=
ote:
>
> On Tue, May 20, 2014 at 10:03:43AM +1000, Stephen Rothwell wrote:
> > Is this a request for inclusion of those branches into linux-next
> > separately from the scsi tree itself?
>=20
> James said he wants to include it in the scsi tree, but given how late
> we are in the cycle I'd love to see separate exposure until that happens
> on a temporary basis.

OK, I have added them from today (called scsi-core and scsi-drivers).
James, feel free to yell if that is not OK.  If these are to stay
longer term (and I have no objections given your list of requirements),
then you should rename the branches (maybe to -next instead of -3.16).

These will be merged after the scsi tree so that they effectively
disappear from my radar when they have been merged into James' tree.

Currently you are the only contact for problems - let me know if I
should add someone else (or a list).

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your branches have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to James (or ask him
to fetch).  They are allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/BLXwGnY2=g.BoJG1vfX9+Rw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTe+liAAoJEMDTa8Ir7ZwVWPkP+gNQnvMEJzbzemODiQBIudOd
uqfWlZlaf1jYWuaoMPj9kXTL16At/1IjDlqSDzKIJKpOwc4MrfdKB/4Qcregskxi
+u1AvgV+oVAqDcg+DeelfOXH+pCiGGN2g6nR7Q+fYo+QXkQxSZIAhxfFaQ/AX+fV
wt1Xz4PB6Nqq/UGGeWn3KMJdYJmnHDv5+txvzB/E4amZ4WhzpyccMlPMXhxYZ/Fd
V+l08Yr5wOEtqUwd6kjnTthm0+tw+P7FgM+mzxZWLgGcDV08KeYgTj3kPBGMh4e8
HyaSuuozRarG//uAz6Fq3LZ+eSaZiOu5yfTumPCIKdH+SVypuDk47DHwNYkfvIgq
Hmtepv6dhnEOVvkvbCN8e8VGQ8L74SN8UYpSi+J1T6GdjZzIbqFL2WzpJooq7P4w
0D/Wodc5zHX8pTAIdeCW7eymZW5HJMxWFu5VaLFO1dhV249onFq2RW4Pazmj+Xha
t3IgTSZ+28eyT6/Oddjcu8+YNknC2hlQmElgTBxArgjEvvVL38yvIrFsjIeSMdrt
NGlBgT4brfV/L33Z9v+ru2P09+s8isrhdF5G49oHIfbPbBaDvz0SSGkqmc0sm1Yr
UMkrCeJydfRjbbVdwdGZtz8v7i1sAgUFl6R6KArG7uptWKrrDz1N3aCro8L4Uw3a
GmFJIKvZsmdFHy9Tsdli
=YPMm
-----END PGP SIGNATURE-----

--Sig_/BLXwGnY2=g.BoJG1vfX9+Rw--
