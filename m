From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] SCSI: Fix potential out-of-bounds access in drivers/scsi/sd.c
Date: Mon, 09 Sep 2013 08:25:30 +0200
Message-ID: <522D69DA.2070103@suse.de>
References: <Pine.LNX.4.44L0.1309061054390.1165-100000@iolanthe.rowland.org> <522A01AB.4010508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3IIGZc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Sep 2013 02:25:32 -0400
In-Reply-To: <522A01AB.4010508@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, richard@r-senior.demon.co.uk, ltuikov@yahoo.com, Andrey Konovalov <andreyknvl@google.com>, Kostya Serebryany <kcc@google.com>

On 09/06/2013 06:24 PM, Paolo Bonzini wrote:
> Il 06/09/2013 17:49, Alan Stern ha scritto:
>> This patch fixes an out-of-bounds error in sd_read_cache_type(), fou=
nd
>> by Google's AddressSanitizer tool.  When the loop ends, we know that
>> "offset" lies beyond the end of the data in the buffer, so no Cachin=
g
>> mode page was found.  In theory it may be present, but the buffer si=
ze
>> is limited to 512 bytes.
>>
>> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>> Reported-by: Dmitry Vyukov <dvyukov@google.com>
>> CC: <stable@vger.kernel.org>
>=20
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>=20
Acked-by: Hannes Reinecke <hare@suse.de>

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
