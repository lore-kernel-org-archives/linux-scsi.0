From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] mpt2sas: Fix secure erase premature termination.
Date: Mon, 21 Nov 2016 10:53:32 +0100
Message-ID: <20161121095307.xhexu2hjfyt52ybs@linux-x5ow.site>
References: <1479469369-15066-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <20161118115428.GA12997@kroah.com>
 <CA+RiK67B6CJtw9B0Omisp2h1EgnRsCf77bTtmw294Rscyqu8yg@mail.gmail.com>
 <20161121094138.GA16352@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58409 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751754AbcKUJxi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 04:53:38 -0500
Content-Disposition: inline
In-Reply-To: <20161121094138.GA16352@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, stable@vger.kernel.org, Andrey Grodzovsky <andrey2805@gmail.com>, Christoph Hellwig <hch@infradead.org>, jejb@kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Sathya Prakash <Sathya.Prakash@broadcom.com>

On Mon, Nov 21, 2016 at 10:41:38AM +0100, Greg KH wrote:
> On Mon, Nov 21, 2016 at 03:05:38PM +0530, Suganath Prabu Subramani wrote:
> > Commit id and other details are given below:
> > 
> > commit 18f6084a989ba1b38702f9af37a2e4049a924be6
> > Author: Andrey Grodzovsky <andrey2805@gmail.com>
> > Date:   Thu Nov 10 09:35:27 2016 -0500
> > 
> >     scsi: mpt3sas: Fix secure erase premature termination
> > 
> 
> For what?  I have no context here...

Hi, 

Let me chime in and give you some context. Once upon a time there have been
two LSI/Avago/Broadcom SAS HBA drivers called mpt2sas and mpt3sas. Luckily
they got merged and so we only have to fix bugs in one file instead all of 
it's copies. This was around commit c84b06a48c4d8ac8270624453132f3fa1a4a0f9d
which went in v4.4. This patch looks like the mpt2sas version of above fix for
stable kernels before the mpt{2,3}sas unification (a.k.a pre-4.4).

Hope that helps.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
