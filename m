From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI Core cmd allocation 3/3
Date: Mon, 13 Jan 2003 12:11:29 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030113121129.A16510@beaverton.ibm.com>
References: <3E1A2140.3000408@splentec.com> <20030111180355.B2225@infradead.org> <3E22F369.5080209@splentec.com> <20030113175948.A27650@infradead.org> <3E2310A0.8080308@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E2310A0.8080308@splentec.com>; from luben@splentec.com on Mon, Jan 13, 2003 at 02:16:48PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Mon, Jan 13, 2003 at 02:16:48PM -0500, Luben Tuikov wrote:
> Christoph Hellwig wrote:
> > 
> > Well, where do you actually _need_ scsi_get_command(), that's the question.
> > 
> > I see the purpose, but I don't see it actually used.
> 
> The scsi devices discovery code *may* use it.

Then do so in another patch.

> If a global variable is used in a couple of files, belonging
> to the same functionality, providing a unified service, and if
> there's more than one of them, then they are better organized
> as such as I've outlined.

Then move all the scsi globals into it. But, that should be a separate
patch.

> > and stuff like:
> > 
> > +       if (!dev) return NULL;
> > +       if (!dev->host) return NULL;
> > 
> > doesn't even seem to be K&R to me :)
> 
> Christoph, please, this is an *inline* function -- it doesn't have to be
> 20 lines if it can be 10.

You should match the other kernel code as much as possible, it makes it
easier for other kernel developers to read it.

-- Patrick Mansfield
