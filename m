From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Move scsi.h, hosts.h to include/linux/scsi ?
Date: Mon, 17 Feb 2003 13:53:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030217125334.GA3346@mars.ravnborg.org>
References: <20030216211422.GD8572@mars.ravnborg.org> <20030217121840.A24543@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030217121840.A24543@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org

On Mon, Feb 17, 2003 at 12:18:40PM +0000, Christoph Hellwig wrote:

> I'd prefer either
> 
> 	include/scsi/core.h
> 	include/scsi/hba.h

Hmm, hba = Host Bus Adapter.
I did not see this abbrevation used in scsi.h, neither hosts.h

> 	include/scsi/upper.h

How much does upper.h differ from the current hosts.h?

In general just combining all the stuff in a single scsi.h file
(the other alternative)  looks ugly to me.
If prefer cleaner and more distributed information.

> 
> plus a drivers/scsi/scsiP.h for stuff private to the midlayer.
But then the usage is restricted to users in drivers/scsi - and
not anything living in arch/* - OK?

Anyway - I'm prepared to do some trivial update of include statements
all over the tree. But I'm not the right person to do the suggested
split-up.
So if anyone step forwards to do the split-up, I will be glad to help
sort out the usage around in the kernel tree.

The SCSI subsystem should be in the same state before and after,
meaning that there should not be any left-overs from such a simple
operation.

	Sam
