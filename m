From: maximilian attems <janitor@sternwelten.at>
Subject: Re: [patch-kj] remove old ifdef'd code from
Date: Tue, 22 Jun 2004 10:44:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622084440.GB1531@sputnik.stro.at>
References: <20040621182918.GX1545@sputnik.stro.at> <20040621183140.GA22588@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:49860 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S261369AbUFVIoi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 04:44:38 -0400
Content-Disposition: inline
In-Reply-To: <20040621183140.GA22588@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: garloff@suse.de, linux-scsi@vger.kernel.org

hello Christoph,

thanks for the feedback.

On Mon, 21 Jun 2004, Christoph Hellwig wrote:

> On Mon, Jun 21, 2004 at 08:29:18PM +0200, maximilian attems wrote:
> > 
> >  From: Domen Puncer <domen@coderock.org>
> >  Patches to remove some old ifdefs.
> >  Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
> 
> While the changes are okay, this driver is beeing changed rapidly and I
> have a patch pending that's a supertset of yours.  So please don't apply
> James.

are you referring to the dc390 driver patches?
what about the aic7xxx and the aic79xx?
please precise so that i can drop from next kj patch set
the ones you are working on.

a++ max




