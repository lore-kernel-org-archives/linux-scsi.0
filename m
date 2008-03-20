From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] a100u2w: fix bitmap lookup routine
Date: Thu, 20 Mar 2008 09:17:22 -0500
Message-ID: <1206022642.3038.6.camel@localhost.localdomain>
References: <20080317123200.GA17756@APFDCB5C>
	 <1205765204.6767.129.camel@localhost.localdomain>
	 <20080319142419.GA27779@devserv.devel.redhat.com>
	 <20080320135518W.tomof@acm.org> <20080320093448.GA30888@APFDCB5C>
	 <20080320141242.GA14790@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58060 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756193AbYCTOR0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 10:17:26 -0400
In-Reply-To: <20080320141242.GA14790@devserv.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, FUJITA Tomonori <tomof@acm.org>, linux-scsi@vger.kernel.org, hch@lst.de, dledford@redhat.com, fujita.tomonori@lab.ntt.co.jp

On Thu, 2008-03-20 at 10:12 -0400, Alan Cox wrote:
> > set_bit() and clear_bit() take unsigned long pointer as a bitmap in
> > the second argument on some architectures. I'd rather change the type of
> > allocation_map than proliferating the casts.
> > 
> > This is incremental patch to the original bugfix patch.
> 
> This doesn't apply over the original patch I was sent. Can someone send me
> a single complete patch everyone is happy with.

Actually, could you just verify the original patch from Akinobu Mita?
That's the -rc-fixes candidate.  We can worry about doing bitmaps better
later since it will be for the merge window.  I'll regenerate it against
the tree for you when I get the first one merged.

Thanks,

James


