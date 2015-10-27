From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: restart list search after unlock in
 scsi_remove_target
Date: Tue, 27 Oct 2015 17:33:21 +0100
Message-ID: <1445963601.16404.45.camel@suse.de>
References: <20151019143546.GA7486@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394AbbJ0Qd0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Oct 2015 12:33:26 -0400
In-Reply-To: <20151019143546.GA7486@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Mon, 2015-10-19 at 16:35 +0200, Christoph Hellwig wrote:
> When dropping a lock while iterating a list we must restart the
> search
> as other threads could have manipulated the list under us.=C2=A0=C2=A0=
Without
> this
> we can get stuck in an endless loop.
>=20
> Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I have an official acknowledge from the original author that a 48h long
term test on their side didn't reproduce the lockup as well.

James can we please get the patch included in 4.4 and stable?

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
