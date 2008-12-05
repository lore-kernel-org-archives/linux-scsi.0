From: Olaf Hering <olh@suse.de>
Subject: Re: oops in ibmvstgt
Date: Fri, 5 Dec 2008 11:53:09 +0100
Message-ID: <20081205105309.GA2198@suse.de>
References: <20081203145857.GA10070@suse.de> <20081204212414H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbYLEKxM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 05:53:12 -0500
Content-Disposition: inline
In-Reply-To: <20081204212414H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Thu, Dec 04, FUJITA Tomonori wrote:

> On Wed, 3 Dec 2008 15:58:57 +0100
> Olaf Hering <olh@suse.de> wrote:
> 
> > 
> > change init order to fix crash due to uninitalized shost_data
> 
> I think that calling crq_queue_create leads to the creation of a rport
> so we need to set up everything before that. The current code is racy.
> 
> 
> > No idea if the patch is correct.
> 
> Almost correct, I think. Needs to modify the error handling
> too. Probably, it would be better to call scsi_tgt_alloc_queue before
> crq_queue_create.
> 
> How about this?

Yes, that works for me.
Would be nice to get this into 2.6.28 to avoid a crash.

Olaf
