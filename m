From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] MPT Fusion driver 3.02.06 update
Date: Tue, 26 Oct 2004 18:15:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041026171525.GA15153@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57053AF0CB@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:53005 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261339AbUJZRQL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 13:16:11 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57053AF0CB@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@infradead.org>, jeremy@sgi.com, linux-scsi@vger.kernel.org

> > hooks it needs (e.g. the sas device list)
> > 
> 
> We have to ship with these IOCTLS. Are there any compromise?
> Sounds like you shot down my backup idea; e.g putting this code into 
> seperate file which isn't provided for inclusion, but can be recompiled 
> to link into mptctl?  I don't think we time to pursue your the idea of 
> re-invent everything into the sas-transport layer.

No way.  This is similar to the hbaapi situation with qlogic and emulex.
If you had worked with us early on on an API like I told you multiple times
we'd have something sane now.

Btw, what part of HP badly wants this?  I'm sure Grant and Matthew
could explain them internally what a bad idea this is.

>
> Jeremy Higdon asked me to add this, not SuSE.

Jeremy, can you make sure SuSE has an uptodate transport attribute
implementation ?
