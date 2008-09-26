From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH git latest] drivers/scsi: fixing wrong comment before
	new_buffer_tape()
Date: Fri, 26 Sep 2008 09:20:56 -0700
Message-ID: <1222446056.3971.19.camel@localhost.localdomain>
References: <20080925174948.GA14180@carmen.cs.uiuc.edu>
	 <20080926111300.1dd34009@lxorguk.ukuu.org.uk>
	 <7fcc02550809260905oa17880fi80c94eaacb33dba3@mail.gmail.com>
	 <20080926170937.2983fc29@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52713 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbYIZQVV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2008 12:21:21 -0400
In-Reply-To: <20080926170937.2983fc29@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Kai Makisara <Kai.Makisara@kolumbus.fi>

On Fri, 2008-09-26 at 17:09 +0100, Alan Cox wrote:
> > > Looks true to me for the current versions of the code. In fact it is only
> > > ever called from the initialisation function that I can see so chunks of
> > > the code could simply go away as well as bits of the comment. Ditto the
> > > one in drivers/scsi/st.c
> > >
> > > Acked-by: Alan Cox <alan@redhat.com>
> > >
> > 
> > I am sorry I didn't quite understand. You mean it is true that caller
> > must hold os_scsi_tapes_lock?
> 
> Sorry - I mean what you claim is true - that the comment is incorrect.

So, I think I'm missing a piece of this:  There's no patch in this
thread (I presume it's lurking somewhere on lkml).  Could someone repost
the proposed patch and copy the tape maintainer: Kai Makisara
<Kai.Makisara@kolumbus.fi> to get his input?

Thanks,

James


