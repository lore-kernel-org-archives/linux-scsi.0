From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Mon, 8 Apr 2002 11:18:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0204081118320.46879-100000@beppo>
References: <16udIR-0pQ920C@fmrl04.sul.t-online.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <16udIR-0pQ920C@fmrl04.sul.t-online.com>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: Christoph Hellwig <hch@infradead.org>, sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org

On Mon, 8 Apr 2002, Oliver Neukum wrote:

> On Monday 08 April 2002 17:04, Christoph Hellwig wrote:
> > On Mon, Apr 08, 2002 at 09:18:44AM -0600, sullivan wrote:
> > > I would welcome any thoughts, comments, or suggestions.
> >
> > What is the rationale for doing this?  I think we should rather get people
> > to actually use the UUID= option to mount..
> 
> UUID cannot solve the problem. It identifies filesystems.
> There's a need to identify devices. Not everything
> is a hard drive with a filesystem on it.
> 

Then let's use WWPN/WWNS and/or drive serial #'s to do UUIDs for devices.

-amtt


