From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [ANNOUNCE] MPT Fusion driver 3.01.09 update
Date: Mon, 21 Jun 2004 13:09:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5704925040@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:29570 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266324AbUFURKA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 13:10:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: viro@parcelfarce.linux.theplanet.co.uk, James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Somebody had submitted this change in the last week,
along with the comment in that patch:

"The only way crap below could work..."

I had not seen the patch on this mailing list. 
I would like revert back to its previous bits since I don't see
what was broken with it.  These headers in the lsi folder are 
the mpi interface to the mpt firmware, and are bundled with 
all operating systems, etc. window, netware, solaris, unixware, etc.

Eric Moore


On Monday, June 21, 2004 10:50 AM, Viro wrote:

> 
> 
> On Mon, Jun 21, 2004 at 11:32:10AM -0500, James Bottomley wrote:
> > -typedef int32_t   S32;
> > -typedef u_int32_t U32;
> > +#if defined(unix) || defined(__arm) || defined(ALPHA)
> > +
> > +    typedef signed   int   S32;
> > +    typedef unsigned int   U32;
> > +
> > +#else
> > +
> > +    typedef signed   long  S32;
> > +    typedef unsigned long  U32;
> > +
> > +#endif
> > 
> > Looks highly suspect.  What was wrong with the original?
> 
> They are actually restoring their beloved original.  What was 
> wrong with
> it is left as an exercise for anybody with a clue.
> 
> IOW, the patch is "let's take diff between whatever's in the 
> tree and our
> private repository".
> 
