From: Hannes Reinecke <hare@suse.de>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Mon, 23 Nov 2015 07:55:44 +0100
Message-ID: <5652B870.70302@suse.de>
References: <1447838334.1564.2.camel@ellerman.id.au>
 <1447855399.3974.24.camel@redhat.com>
 <1447894964.15206.0.camel@ellerman.id.au>
 <20151119082325.GA11419@infradead.org> <564DEC41.5010600@suse.de>
 <1448030316.4067.18.camel@localhost.localdomain> <564F3453.9040603@suse.de>
 <1448033323.4067.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbbKWGzu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Nov 2015 01:55:50 -0500
In-Reply-To: <1448033323.4067.24.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, Mark Salter <msalter@redhat.com>, "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org

On 11/20/2015 04:28 PM, Ewan Milne wrote:
> On Fri, 2015-11-20 at 15:55 +0100, Hannes Reinecke wrote:
>> Can't we have a joint effort here?
>> I've been spending a _LOT_ of time trying to debug things here, but
>> none of the ideas I've come up with have been able to fix anything.
>
> Yes.  I'm not the one primarily looking at it, and we don't have a
> reproducer in-house.  We just have the one dump right now.
>
Oh, I got plenty of them :-(

>>
>> I'm almost tempted to increase the count from scsi_alloc_sgtable()
>> by one and be done with ...
>>
>
> That might not fix it if it is a problem with the merge code, though.
>
Of course not. But it'll be a band-aid to keep the customer happy.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
