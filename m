From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] a100u2w: fix bitmap lookup routine
Date: Mon, 17 Mar 2008 09:46:44 -0500
Message-ID: <1205765204.6767.129.camel@localhost.localdomain>
References: <20080317123200.GA17756@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54999 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752765AbYCQOqs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 10:46:48 -0400
In-Reply-To: <20080317123200.GA17756@APFDCB5C>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>, Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>

On Mon, 2008-03-17 at 21:32 +0900, Akinobu Mita wrote:
> This patch is only compile tested.

It looks fine to me ... I don't suppose we can find someone with an
actual card to test it out, could we?

Another observation is that this code is really trying to reinvent
bitmaps, so if someone with a card cares they could convert it over to
the linux bitmap infrastructure.

James


