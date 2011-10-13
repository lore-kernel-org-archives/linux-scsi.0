From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: ib_srpt status
Date: Thu, 13 Oct 2011 15:07:22 -0700
Message-ID: <1318543642.30891.44.camel@haakon2.linux-iscsi.org>
References: <20111012092318.GA9405@lst.de>
	 <CAL1RGDWDa+RiEx2zn9PbsNRdqOOg6nX=z0RAgZM2uH4OLWcxvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDWDa+RiEx2zn9PbsNRdqOOg6nX=z0RAgZM2uH4OLWcxvQ@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: Christoph Hellwig <hch@lst.de>, Barn Van Assche <bvanassche@acm.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-10-12 at 09:17 -0700, Roland Dreier wrote:
> On Wed, Oct 12, 2011 at 2:23 AM, Christoph Hellwig <hch@lst.de> wrote:
> > Hi Roland, hi Nick,
> >
> > what is the status of queueing up ib_srpt for mainline?  It's a very
> > clean looking driver that was submitted 8 month ago and after an initial
> > round of fixes only saw updates for changing core APIs.
> >
> > Keeping it out of tree for so long is a very discuraging story for
> > contributors.
> 
> Where is the latest patch?  I would like to review it and at least
> get it into linux-next...
> 
> I seem to recall having some concerns about the interface -- ie
> some things were done through module params and I don't want
> to be stuck supporting those module params forever.
> 
> Other than that it is likely to be fine to merge.
> 

Hey guys,

I'll post the latest version of ib_srpt in a bit after merging
Christoph's remaining patches..  However, this will be against the v3.2
queued patches in target-pending.git/for-next, as the core cleanups in
the se_cmd release path also effect current ib_srpt code.

--nab
