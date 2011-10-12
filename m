From: Roland Dreier <roland@purestorage.com>
Subject: Re: ib_srpt status
Date: Wed, 12 Oct 2011 09:17:18 -0700
Message-ID: <CAL1RGDWDa+RiEx2zn9PbsNRdqOOg6nX=z0RAgZM2uH4OLWcxvQ@mail.gmail.com>
References: <20111012092318.GA9405@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20111012092318.GA9405@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <rdreier@cisco.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Barn Van Assche <bvanassche@acm.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 12, 2011 at 2:23 AM, Christoph Hellwig <hch@lst.de> wrote:
> Hi Roland, hi Nick,
>
> what is the status of queueing up ib_srpt for mainline? =A0It's a ver=
y
> clean looking driver that was submitted 8 month ago and after an init=
ial
> round of fixes only saw updates for changing core APIs.
>
> Keeping it out of tree for so long is a very discuraging story for
> contributors.

Where is the latest patch?  I would like to review it and at least
get it into linux-next...

I seem to recall having some concerns about the interface -- ie
some things were done through module params and I don't want
to be stuck supporting those module params forever.

Other than that it is likely to be fine to merge.

 - R.
