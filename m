From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Mon, 8 Apr 2002 13:41:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0204081340520.46879-100000@beppo>
References: <200204081907.g38J71S05041@localhost.localdomain>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <200204081907.g38J71S05041@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Oliver Neukum <oliver@neukum.org>, Christoph Hellwig <hch@infradead.org>, sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org

> mjacob@feral.com said:
> > For the current discussion, it seems to me that unlabelled/unimported
> > disks/volumes (i.e., ones w/o a UUID) still can be named unambiguosly
> > by the unwieldy names because you're likely to put a UUID on them very
> > very quickly. Furthermore, a minor amount of effort in userland tools
> > can make the manipulation of said names not as much of a problem.
> 
> I agree, but there are the edge cases where you can't put a UUID on them.
> 
> I think, however, that what the discussion is showing us is that there is no 
> one universal way to get a unique name for a volume, so what we want is some 
> type of pluggable infrastructure which allows us to construct a unique name.

Fair enough!

I would resist constructing names with addresses that can change easily (e.g.,
PortIDs or SCSI Targets, or device instance numbers based on probe order).

-matt


