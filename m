From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Tue, 9 Apr 2002 00:05:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFACC028EF.88946943-ONC1256B95.0078A3EA@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
List-Id: linux-scsi@vger.kernel.org
To: mjacob@feral.com
Cc: James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, Christoph Hellwig <hch@infradead.org>, sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org

> It's more than just a WWN- it really has to be
> the pair of WWNN/WWPN (node && port name) as you
> can have, e.g., a dual ported disk with the same WWNN but
> different WWPNs.

Ok, I thought of WWPN and that it would be sufficient to identify the
target side of a link, isn't it?
Do you really need a pair of WWNN/WWPN, i.e. identical WWPNs might
exist considering different WWNNs?


Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


Matthew Jacob <mjacob@feral.com>@vger.kernel.org on 04/08/2002 10:45:33=
 PM

Please respond to mjacob@feral.com

Sent by:    linux-scsi-owner@vger.kernel.org


To:    Martin Peschke3/Germany/IBM@IBMDE
cc:    James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum
       <oliver@neukum.org>, Christoph Hellwig <hch@infradead.org>, sull=
ivan
       <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org
Subject:    Re: [RFC] Persistent naming of scsi devices




It's more than just a WWN- it really has to be the pair of WWNN/WWPN (n=
ode
&&
port name) as you can have, e.g., a dual ported disk with the same WWNN=
 but
different WWPNs.

On Mon, 8 Apr 2002, Martin Peschke3 wrote:

>
>
> > mjacob@feral.com said:
> > > Then let's use WWPN/WWNS and/or drive serial #'s to do UUIDs for
> > > devices.
> >
> > That's what the persistent binding proposal that started all this u=
ses.
> > However, these strings are incredibly long at best and (in spite of
what
> the
> > SCSI spec says) sometimes include non-printing characters, so you d=
on't
> > necessarily want to be passing them on the command line.
> >
> > James
>
> That's true of course for Fibre Channel WWNs (64 bit).
> Such identifiers might be shorter (or longer)
> depending on the considered interface.
> What could be used for good old parallel attachments?
>
> I would suggest to circumvent problems with non-printing
> characters by means of hexadecimal notation
> (e.g. 0x5007890000a11753 representing a WWN).
>
>
> Mit freundlichen Gr=FC=DFen / with kind regards
>
> Martin Peschke
>
> IBM Deutschland Entwicklung GmbH
> Linux for eServer Development
> Phone: +49-(0)7031-16-2349
>
>
>
>

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
