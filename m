From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Mon, 8 Apr 2002 21:18:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF8B2F3581.590066BE-ONC1256B95.0068B28C@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: mjacob@feral.com, Oliver Neukum <oliver@neukum.org>, Christoph Hellwig <hch@infradead.org>, sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org



> mjacob@feral.com said:
> > Then let's use WWPN/WWNS and/or drive serial #'s to do UUIDs for
> > devices.
>
> That's what the persistent binding proposal that started all this use=
s.
> However, these strings are incredibly long at best and (in spite of w=
hat
the
> SCSI spec says) sometimes include non-printing characters, so you don=
't
> necessarily want to be passing them on the command line.
>
> James

That's true of course for Fibre Channel WWNs (64 bit).
Such identifiers might be shorter (or longer)
depending on the considered interface.
What could be used for good old parallel attachments?

I would suggest to circumvent problems with non-printing
characters by means of hexadecimal notation
(e.g. 0x5007890000a11753 representing a WWN).


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
