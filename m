From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Mon, 8 Apr 2002 13:45:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0204081344500.46879-100000@beppo>
References: <OF8B2F3581.590066BE-ONC1256B95.0068B28C@de.ibm.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE
In-Reply-To: <OF8B2F3581.590066BE-ONC1256B95.0068B28C@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, Christoph Hellwig <hch@infradead.org>, sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org


It's more than just a WWN- it really has to be the pair of WWNN/WWPN (n=
ode &&
port name) as you can have, e.g., a dual ported disk with the same WWNN=
 but
different WWPNs.

On Mon, 8 Apr 2002, Martin Peschke3 wrote:

>=20
>=20
> > mjacob@feral.com said:
> > > Then let's use WWPN/WWNS and/or drive serial #'s to do UUIDs for
> > > devices.
> >
> > That's what the persistent binding proposal that started all this u=
ses.
> > However, these strings are incredibly long at best and (in spite of=
 what
> the
> > SCSI spec says) sometimes include non-printing characters, so you d=
on't
> > necessarily want to be passing them on the command line.
> >
> > James
>=20
> That's true of course for Fibre Channel WWNs (64 bit).
> Such identifiers might be shorter (or longer)
> depending on the considered interface.
> What could be used for good old parallel attachments?
>=20
> I would suggest to circumvent problems with non-printing
> characters by means of hexadecimal notation
> (e.g. 0x5007890000a11753 representing a WWN).
>=20
>=20
> Mit freundlichen Gr=FC=DFen / with kind regards
>=20
> Martin Peschke
>=20
> IBM Deutschland Entwicklung GmbH
> Linux for eServer Development
> Phone: +49-(0)7031-16-2349
>=20
>=20
>=20
>=20

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
