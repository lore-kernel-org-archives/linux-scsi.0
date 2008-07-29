From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: tools support for non-512 byte sector sizes
Date: Tue, 29 Jul 2008 13:56:14 -0500
Message-ID: <1217357774.6103.54.camel@localhost.localdomain>
References: <488F524F.6020905@redhat.com>
	 <20080729182611.GB24924@parisc-linux.org>
	 <1217356645.6103.48.camel@localhost.localdomain>
	 <yq13alsr0g0.fsf@sermon.lab.mkp.net>  <488F6758.8080907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <488F6758.8080907@redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: rwheeler@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>, linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Matt Domsch <Matt_Domsch@Dell.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-07-29 at 14:54 -0400, Ric Wheeler wrote:
> Martin K. Petersen wrote:
> >>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> >>>>>>             
> >
> > James> The problem, which ata_ram also suffers, is that the tools we
> > James> most need to test are the ones for manipulating non volatile
> > James> characteristics (like partition tables).  We'd really like the
> > James> disk contents to survive reboot for this ...
> >
> > Yeah, I should add that I wanted persistence too.  I went through a
> > whole stack (well, 5-6 or so) fibre channel drives from various
> > vendors and attempted to low-level format them to 4KB sectors.  Most
> > of them laughed in my face.  One of them tried to comply and
> > irreparably confused its firmware in the process.
> >
> > Just yesterday I received a couple of prototype drives in the mail.
> > I'll ask the vendor whether they support 4KB and if so I'll give them
> > a whirl.
> >   
> Isn't this a great use case for a SCSI target device where our target 
> can be a software disk on a remote host? What is missing for us to put 
> something like that together?

Technically nothing.  Tomo should already have one for the STGT test
infrastructure (I've cc'd him).

James


