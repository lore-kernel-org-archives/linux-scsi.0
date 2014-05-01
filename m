From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCHv2 RESEND 0/9] target: Save memory on unused
 se_dev_entrys and se_luns
Date: Thu, 01 May 2014 14:21:08 -0700
Message-ID: <1398979268.24007.26.camel@haakon3.risingtidesystems.com>
References: <1395704598-31073-1-git-send-email-agrover@redhat.com>
	 <5358406B.5040906@redhat.com> <20140425053458.GA30932@lst.de>
	 <53628A29.1080207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49399 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaEAVVJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2014 17:21:09 -0400
In-Reply-To: <53628A29.1080207@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 2014-05-01 at 10:53 -0700, Andy Grover wrote:
> On 04/24/2014 10:34 PM, Christoph Hellwig wrote:
> > On Wed, Apr 23, 2014 at 03:36:27PM -0700, Andy Grover wrote:
> >> Does this set look ok, or any other changes needed? Just haven't heard
> >> anything.
> >
> > the series looks reasonable to me, at least for the points I previously
> > comment on.
> >
> > Cheers,
> > 	Christoph
> >
> > p.s. it helps to cc me if you want a quick reply.
> 
> Cool, thanks. Will do in the future.
> 
> Nick, thoughts?
> 

So now that target code (plus Sagi's patches) is finally working
correctly with active I/O shutdown with iser + friends, I'm not exactly
crazy about introducing a bunch of changes that potentially break long
standing assumptions about how se_lun + se_dev_entry pointers are
accessed.

That said, I'd much rather see proper percpu refcounting for
se_dev_entry introduced ahead of these types of memory space related
optimizations.

--nab





