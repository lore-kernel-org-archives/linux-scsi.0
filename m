From: "Martin Peschke3" <MPESCHKE@DE.IBM.COM>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Wed, 10 Apr 2002 17:52:45 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFDDCB335C.1A38AFF1-ONC1256B97.00555052@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: mjacob@feral.com
Cc: James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, Christoph Hellwig <hch@infradead.org>, sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org

Matt,

> > > It's more than just a WWN- it really has to be
> > > the pair of WWNN/WWPN (node && port name) as you
> > > can have, e.g., a dual ported disk with the same WWNN but
> > > different WWPNs.
> >
> > Ok, I thought of WWPN and that it would be sufficient to identify t=
he
> > target side of a link, isn't it? Do you really need a pair of
WWNN/WWPN,
> > i.e. identical WWPNs might exist considering different WWNNs?
>
> If the numbering is NAA=3D2 (2 in the top nibble), you can always der=
ive
the
> WWNN from the WWPN. But that's only true for NAA=3D2.
>
> In *practice*, WWPN might be enough,  but if we're doing things that
formally
> and fully ID a device, and considering that iSCSI identifiers are 255
bytes or
> better, two 64 bit ids for Fibre Channel devices is not unreasonable =
to
allow
> for.
>
> -matt

If there are cases which require WWNN+WWPN to identify a
=46C port then a you would need this pair to query a FC ports
D_ID. I wonder why this is not reflected in the FC name server
specification, FC-GS-3, (see GID_PN for example).


Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
