From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] Silencing 'killing requests for dead queue'
Date: Thu, 10 Nov 2011 13:10:29 +1100
Message-ID: <20111110131029.be09b1080f3fe22d5fa86fe4@canb.auug.org.au>
References: <1320824364-8510-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_Nov_2011_13_10_29_+1100_6+AUS+vyEcgBpX0/"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from calzone.tip.net.au ([203.10.76.15]:59066 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1KJCKk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2011 21:10:40 -0500
In-Reply-To: <1320824364-8510-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

--Signature=_Thu__10_Nov_2011_13_10_29_+1100_6+AUS+vyEcgBpX0/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Wed,  9 Nov 2011 08:39:24 +0100 Hannes Reinecke <hare@suse.de> wrote:
>
> When we tear down a device we try to flush all outstanding
> commands in scsi_free_queue(). However the check in
> scsi_request_fn() is imperfect as it only signals that
> we _might start_ aborting commands, not that we've actually
> aborted some.
> So move the printk inside the scsi_kill_request function,
> this will also give us a hint about which commands are aborted.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

[I realise that you have already committed this fix, but I thought I
should test it anyway.]

ipr_init is now down to 2543495 usecs (down from 494857993 usecs without
this patch) and the machine boots as well as can be expected.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Nov_2011_13_10_29_+1100_6+AUS+vyEcgBpX0/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOuzKVAAoJEECxmPOUX5FEByAP+gJbhZJmMTcckKoFRZsJbIzf
ZqJhEqyY6zAcld+WcrqpEbIFty7IiBmrwG3A6WiUL4ong991ayHtZYgQbJC7NT/A
JvzNAnx15ADVJjKpSpNy5R2hieJ2iVH+ilkqPD2QKcgEk4TyQjWZ2HJ/gbhLZVfi
EK4PGPPdRIprV3aClieuVu6vT0Dad7GtzWACfXytizNAZ7cr4E+1/ftxUIQq/gCN
SR4nHIP6/BnGOGtTcHQ9HeDN8uEiEfNHTvT3z6N51cfNeZrkKdPKbEe6nC2pOiHW
EeSSBR6c4+XrU3jUfs7/alJZr8lj3aqil4wsGKYpfMBpEzpkLRxLc2ZjrLAxMnHM
wqBznhlvyVQ3NluuY8XTLN2YUqQR4dKriPIGNa3i4vNGTa8tjbKrEMXo7qn6FLYP
rgJCeeCd7G9aqse2kpDyDycIlnPmbBVd8bBWDQtWuZCIDshtqTGosTuuFDIyeICu
ZJ3c1CrqpK/MwPaM5GWczJvxobvG0Ri4hvbJXDPuc8SWjiCTKd9/E3XywHOJUe/Z
gvbe2X9xz8YfPve6AiD7YyD2CLUPHFKz0o+K/sN4QF12Zz/PAVCXIRF025ic7UaE
AIZCDb6XMfL3djKHTqfvqnMobxzhHkXSMaPA2V95dlMRRwrnjnLk5rDR0X6UY+aE
JXvidAC8kGY/4fGDg/vx
=i0ld
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Nov_2011_13_10_29_+1100_6+AUS+vyEcgBpX0/--
