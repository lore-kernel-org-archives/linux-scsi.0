From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH git latest] drivers/scsi: fixing wrong comment before
 new_buffer_tape()
Date: Fri, 26 Sep 2008 17:09:37 +0100
Message-ID: <20080926170937.2983fc29@lxorguk.ukuu.org.uk>
References: <20080925174948.GA14180@carmen.cs.uiuc.edu>
	<20080926111300.1dd34009@lxorguk.ukuu.org.uk>
	<7fcc02550809260905oa17880fi80c94eaacb33dba3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45350 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751983AbYIZQJi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2008 12:09:38 -0400
In-Reply-To: <7fcc02550809260905oa17880fi80c94eaacb33dba3@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> > Looks true to me for the current versions of the code. In fact it is only
> > ever called from the initialisation function that I can see so chunks of
> > the code could simply go away as well as bits of the comment. Ditto the
> > one in drivers/scsi/st.c
> >
> > Acked-by: Alan Cox <alan@redhat.com>
> >
> 
> I am sorry I didn't quite understand. You mean it is true that caller
> must hold os_scsi_tapes_lock?

Sorry - I mean what you claim is true - that the comment is incorrect.
