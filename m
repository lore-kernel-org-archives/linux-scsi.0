From: "Aron Zeh" <ARZEH@de.ibm.com>
Subject: Re: Fwd: [PATCH] [was SCSI host numbers? ]
Date: Tue, 9 Apr 2002 00:29:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFBF6FD36A.25698EED-ONC1256B95.007B6205@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-Id: linux-scsi@vger.kernel.org
To: nahshon@actcom.co.il
Cc: linux-scsi@vger.kernel.org



Hi Itai,

I have finally found the time to verify your patch and it worked as
expected.
I think it would be a good idea to have it integrated into the kernel as
soon as possible.
Could you resend it for that purpose?

Aron


Itai Nahshon <nahshon@actcom.co.il> on 03/28/2002 02:38:40 AM

Please respond to nahshon@actcom.co.il

To:    Aron Zeh/Germany/IBM@IBMDE
cc:    linux-scsi@vger.kernel.org
Subject:    Re: Fwd: [PATCH] [was SCSI host numbers? ]


On Wednesday 27 March 2002 00:59 am, Aron Zeh wrote:
> Itai,
>
> you are right, of course.
>
> I have reread the code and yes, with my patch, in your scenario, host B
> would be assigned the host_nos of A, correct?

Yes.

> Your patch, however, guarrantees that hostnos are preserved.
> For my purposes I never considered it important for the host-numbers to
be
> preserved as this is done internally by the driver I'm writing. Sorry.

Actally the requirement for host_no reservation caused this
bug in the first place. It is possible to load scsi_mod with an option:
             modprobe scsi_mod scsihosts=HA1:HA2:HA3 ...
This initializes scsi_host_no_list with the reserved host_no and
max_scsi_hosts with the size of the initial list.

> Since your fix should be fine for me, too, I'll try it out with many
> adapters. It should be a good fix for 2.4.

Thank you.

> Incidentally, is anybody working on a new persistent mapping scheme for
> 2.5?

IMHO there is so much to be done on 2.5 and a complete rewrite
of persistent mapping scheme is just a small part of it.

As an absolute minimum I think variables must be renamed to something
that resembles their actual use. I hope that Jens Axboe (who's listed
as maintainer) and Linus plan farther that that.

>
> Aron

-- Itai




