From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Subject: [PATCH] tgt: use KMEM_CACHE
Date: Wed, 24 Oct 2007 21:25:24 -0600
Message-ID: <20071025032524.GJ27248@parisc-linux.org>
References: <20071024235611B.tomof@acm.org> <20071024195755.14e9c37f@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60594 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbXJYDZZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2007 23:25:25 -0400
Content-Disposition: inline
In-Reply-To: <20071024195755.14e9c37f@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: FUJITA Tomonori <tomof@acm.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Wed, Oct 24, 2007 at 07:57:55PM -0700, Arjan van de Ven wrote:
> On Thu, 25 Oct 2007 01:21:29 +0900
> FUJITA Tomonori <tomof@acm.org> wrote:
> > -	scsi_tgt_cmd_cache = kmem_cache_create("scsi_tgt_cmd",
> > -					       sizeof(struct
> > scsi_tgt_cmd),
> > -					       0, 0, NULL);
> > +	scsi_tgt_cmd_cache =  KMEM_CACHE(scsi_tgt_cmd, 0);
> 
> I have a question that is not described in your change log: why would
> you want to do this change? kmem_cache_create() is THE linux API to
> achieve this.... why would you not want to use it?? I'm sure you have a
> good reason for this change, but I can't figure out what that is from
> the changelog of your patch.

Looks like the preferred API was changed in May by clameter; see
commit 0a31bd5f2bbb6473ef9d24f0063ca91cfa678b64

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
