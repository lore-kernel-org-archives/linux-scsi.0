From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch-kj] remove old ifdef'd code from
Date: Tue, 22 Jun 2004 09:47:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622084714.GA31811@infradead.org>
References: <20040621182918.GX1545@sputnik.stro.at> <20040621183140.GA22588@infradead.org> <20040622084440.GB1531@sputnik.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:65409 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261451AbUFVIrR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 04:47:17 -0400
Content-Disposition: inline
In-Reply-To: <20040622084440.GB1531@sputnik.stro.at>
List-Id: linux-scsi@vger.kernel.org
To: maximilian attems <janitor@sternwelten.at>
Cc: Christoph Hellwig <hch@infradead.org>, garloff@suse.de, linux-scsi@vger.kernel.org

On Tue, Jun 22, 2004 at 10:44:40AM +0200, maximilian attems wrote:
> > While the changes are okay, this driver is beeing changed rapidly and I
> > have a patch pending that's a supertset of yours.  So please don't apply
> > James.
> 
> are you referring to the dc390 driver patches?

Yes.

> what about the aic7xxx and the aic79xx?

There have been rumors on linux-scsi that adaptec is starting to maintain
them again. OTOH they'll need to redo their patches in small steps anyway
so your patches look fine to me.

