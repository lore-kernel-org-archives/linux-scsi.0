From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [patch RESEND] atp870u: 64 bit bug in atp885_init()
Date: Wed, 9 Dec 2015 19:11:15 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1512091907590.2491@hadrien>
References: <55B9CA3B.1030205@suse.de> <20151209102453.GE3173@mwanda> <20151209115339.46a09d94@lxorguk.ukuu.org.uk> <20151209134512.GA5177@mwanda> <20151209141459.41a237c9@lxorguk.ukuu.org.uk> <20151209174819.GB5177@mwanda>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151209174819.GB5177@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, "James E.J. Bottomley" <JBottomley@odin.com>, Ondrej Zary <linux@rainbow-software.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org



On Wed, 9 Dec 2015, Dan Carpenter wrote:

> We should add a tag to indicate that we are sending a patch for a crappy
> driver.
>
> IMHO-this-driver-is-garbage: Your Name <email>
>
> If it got 10 votes of no confidence it would be moved to staging and
> then deleted.

Forgive my ignorance, but what is the exact procedure?  For example, the
following file: drivers/pcmcia/vrc4173_cardu.c contains the following
code: INIT_WORK(&socket->tq_work, cardu_bh, socket);.  The last time
INIT_WORK took three arguments was Linux 2.6.19, so I think no one has
been compiling this code recently.  There would be the .c file and the
associated .h file to move to staging, but it's less clear to me eg what
to do with the Kconfig entry and the Makefile entry.  And is there
anything else to take into account?

thanks,
julia
