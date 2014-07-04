From: Hannes Reinecke <hare@suse.de>
Subject: Re: tgt infrastructure removal
Date: Fri, 04 Jul 2014 12:54:13 +0200
Message-ID: <53B687D5.3080105@suse.de>
References: <1397557614-21243-1-git-send-email-hch@lst.de> <20140704093643.GA21482@infradead.org> <53B67976.4030900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757696AbaGDKyR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2014 06:54:17 -0400
In-Reply-To: <53B67976.4030900@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>, Nathan Fontenot <nfont@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On 07/04/2014 11:52 AM, Paolo Bonzini wrote:
> Il 04/07/2014 11:36, Christoph Hellwig ha scritto:
>> I got an older Ack from Tomo for the removal, and some sort of acks
>> for the ibmvscsi target removal from Brian, Paolo and Nathan.
>>
>> Can I get some formal reviews for the code removal patches (1-4) so =
I
>> can queue this up for 3.17?
>
> Not that there's much to review there. :)
>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>
And I checked with our partners which might have some interest in=20
keeping it. Turns out they haven't.

So:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
