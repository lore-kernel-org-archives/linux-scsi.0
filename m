From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Mon, 8 Apr 2002 15:17:40 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0204081513320.46879-100000@beppo>
References: <OFACC028EF.88946943-ONC1256B95.0078A3EA@de.ibm.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <OFACC028EF.88946943-ONC1256B95.0078A3EA@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Oliver Neukum <oliver@neukum.org>, Christoph Hellwig <hch@infradead.org>, sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org

On Tue, 9 Apr 2002, Martin Peschke3 wrote:

> > It's more than just a WWN- it really has to be
> > the pair of WWNN/WWPN (node && port name) as you
> > can have, e.g., a dual ported disk with the same WWNN but
> > different WWPNs.
> 
> Ok, I thought of WWPN and that it would be sufficient to identify the
> target side of a link, isn't it? Do you really need a pair of WWNN/WWPN,
> i.e. identical WWPNs might exist considering different WWNNs?

If the numbering is NAA=2 (2 in the top nibble), you can always derive the
WWNN from the WWPN. But that's only true for NAA=2.

In *practice*, WWPN might be enough,  but if we're doing things that formally
and fully ID a device, and considering that iSCSI identifiers are 255 bytes or
better, two 64 bit ids for Fibre Channel devices is not unreasonable to allow
for.

-matt


