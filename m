From: Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] a100u2w: fix bitmap lookup routine
Date: Thu, 20 Mar 2008 10:12:42 -0400
Message-ID: <20080320141242.GA14790@devserv.devel.redhat.com>
References: <20080317123200.GA17756@APFDCB5C> <1205765204.6767.129.camel@localhost.localdomain> <20080319142419.GA27779@devserv.devel.redhat.com> <20080320135518W.tomof@acm.org> <20080320093448.GA30888@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791AbYCTONA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 10:13:00 -0400
Content-Disposition: inline
In-Reply-To: <20080320093448.GA30888@APFDCB5C>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: FUJITA Tomonori <tomof@acm.org>, alan@redhat.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hch@lst.de, dledford@redhat.com, fujita.tomonori@lab.ntt.co.jp

> set_bit() and clear_bit() take unsigned long pointer as a bitmap in
> the second argument on some architectures. I'd rather change the type of
> allocation_map than proliferating the casts.
> 
> This is incremental patch to the original bugfix patch.

This doesn't apply over the original patch I was sent. Can someone send me
a single complete patch everyone is happy with.
