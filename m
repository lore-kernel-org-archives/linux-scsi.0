From: viro@parcelfarce.linux.theplanet.co.uk
Subject: Re: [ANNOUNCE] MPT Fusion driver 3.01.09 update
Date: Mon, 21 Jun 2004 18:23:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621172303.GA12308@parcelfarce.linux.theplanet.co.uk>
References: <0E3FA95632D6D047BA649F95DAB60E5704925040@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9675 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266335AbUFURXJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 13:23:09 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5704925040@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jun 21, 2004 at 01:09:43PM -0400, Moore, Eric Dean wrote:
> Somebody had submitted this change in the last week,
> along with the comment in that patch:
> 
> "The only way crap below could work..."

Yes?  Care to take a look at your definition of S64?  Now think for a moment
what it will produce on a big-endian box.

> I had not seen the patch on this mailing list. 
> I would like revert back to its previous bits since I don't see
> what was broken with it.  These headers in the lsi folder are 
> the mpi interface to the mpt firmware, and are bundled with 
> all operating systems, etc. window, netware, solaris, unixware, etc.

> > > +#if defined(unix) || defined(__arm) || defined(ALPHA)
> > > +
> > > +    typedef signed   int   S32;
> > > +    typedef unsigned int   U32;
> > > +
> > > +#else
> > > +
> > > +    typedef signed   long  S32;
> > > +    typedef unsigned long  U32;
> > > +
> > > +#endif

... and that is ugly beyond words.
