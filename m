From: Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] a100u2w: fix bitmap lookup routine
Date: Thu, 20 Mar 2008 12:34:37 -0400
Message-ID: <20080320163437.GA21498@devserv.devel.redhat.com>
References: <20080317123200.GA17756@APFDCB5C> <1205765204.6767.129.camel@localhost.localdomain> <20080319142419.GA27779@devserv.devel.redhat.com> <20080320135518W.tomof@acm.org> <20080320093448.GA30888@APFDCB5C> <20080320141242.GA14790@devserv.devel.redhat.com> <1206022642.3038.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbYCTQex (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 12:34:53 -0400
Content-Disposition: inline
In-Reply-To: <1206022642.3038.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Cox <alan@redhat.com>, Akinobu Mita <akinobu.mita@gmail.com>, FUJITA Tomonori <tomof@acm.org>, linux-scsi@vger.kernel.org, hch@lst.de, dledford@redhat.com, fujita.tomonori@lab.ntt.co.jp

On Thu, Mar 20, 2008 at 09:17:22AM -0500, James Bottomley wrote:
> Actually, could you just verify the original patch from Akinobu Mita?
> That's the -rc-fixes candidate.  We can worry about doing bitmaps better
> later since it will be for the merge window.  I'll regenerate it against
> the tree for you when I get the first one merged.

Seems to work with the basic testing I can do
