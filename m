From: Tigran Aivazian <tigran@veritas.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Mon, 8 Apr 2002 19:45:49 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0204081941080.2762-100000@einstein.homenet>
References: <20020408160445.A25213@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <20020408160445.A25213@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: sullivan <sullivan@austin.ibm.com>, linux-scsi@vger.kernel.org

On Mon, 8 Apr 2002, Christoph Hellwig wrote:

> On Mon, Apr 08, 2002 at 09:18:44AM -0600, sullivan wrote:
> > I would welcome any thoughts, comments, or suggestions.
>
> What is the rationale for doing this?  I think we should rather get people
> to actually use the UUID= option to mount..

Imagine an appliance serving out data from filesystems but also directly
connected to a tape library (or, even better, many such libraries),
obviously for direct backups.  After reshuffling devices in the library
(e.g. by breaking some of them :) Linux will reorder the tape devices in
the way it finds them which will completely screw up the windows client
software that is controlling the actual backup. So persistent naming of
such devices is a good idea but to implement it is far from trivial. I am
assuming the folks at IBM did this "non-trivial bit".

Regards,
Tigran

