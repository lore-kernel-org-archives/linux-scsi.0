From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Mon, 8 Apr 2002 11:34:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0204081129180.46879-100000@beppo>
References: <200204081828.g38ISgp04833@localhost.localdomain>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <200204081828.g38ISgp04833@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Oliver Neukum <oliver@neukum.org>, Christoph Hellwig <hch@infradead.org>, sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org


A discussion about this kind of stuff went on at Sun in 1989. You want
unambigious physical attribute names that are absolutely precise- this is what
you get with, say, OpenBoot pathnames. But you don't want people to have to
deal with them because they're unwieldy. Instead, you want 'friendly'
names. For the OBP discussions back at Sun, this ended up as the 'devalias'
command for the prom, so 'Fred' could be /iommu@foo/sbus@bar/disk@wank, etc.

For the current discussion, it seems to me that unlabelled/unimported
disks/volumes (i.e., ones w/o a UUID) still can be named unambiguosly by the
unwieldy names because you're likely to put a UUID on them very very
quickly. Furthermore, a minor amount of effort in userland tools can make the
manipulation of said names not as much of a problem.

Sorry if I came into the discussion late.

-matt


On Mon, 8 Apr 2002, James Bottomley wrote:

> mjacob@feral.com said:
> > Then let's use WWPN/WWNS and/or drive serial #'s to do UUIDs for
> > devices. 
> 
> That's what the persistent binding proposal that started all this uses.  
> However, these strings are incredibly long at best and (in spite of what the 
> SCSI spec says) sometimes include non-printing characters, so you don't 
> necessarily want to be passing them on the command line.
> 
> James
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

