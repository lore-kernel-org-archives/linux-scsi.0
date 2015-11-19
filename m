From: Hannes Reinecke <hare@suse.de>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Thu, 19 Nov 2015 16:35:29 +0100
Message-ID: <564DEC41.5010600@suse.de>
References: <1447838334.1564.2.camel@ellerman.id.au> <1447855399.3974.24.camel@redhat.com> <1447894964.15206.0.camel@ellerman.id.au> <20151119082325.GA11419@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756521AbbKSPfd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2015 10:35:33 -0500
In-Reply-To: <20151119082325.GA11419@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>
Cc: Mark Salter <msalter@redhat.com>, "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org

On 11/19/2015 09:23 AM, Christoph Hellwig wrote:
> It's pretty much guaranteed a block layer bug, most likely in the
> merge bios to request infrastucture where we don't obey the merging
> limits properly.
>=20
> Does either of you have a known good and first known bad kernel?

Well, I have been fighting a similar issue for several months now,
albeit with multipath enabled. Haven't had much progress with this,
sadly.
Seeing that this is our distro kernel it might or might not be
related; however, as the symptoms are identical there still is a
chance that this is actually a generic block-layer problem.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
