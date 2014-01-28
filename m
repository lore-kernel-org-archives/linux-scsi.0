From: Hannes Reinecke <hare@suse.de>
Subject: Re: status of drivers/scsi/scsi_tgt_lib.c
Date: Tue, 28 Jan 2014 12:58:36 +0100
Message-ID: <52E79B6C.3090809@suse.de>
References: <20140124131525.GA30922@infradead.org>	<20140125.124832.1568838937885770665.fujita.tomonori@lab.ntt.co.jp>	<20140127075038.GA18590@infradead.org> <20140128.004504.1305564732068179852.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105AbaA1L6j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jan 2014 06:58:39 -0500
In-Reply-To: <20140128.004504.1305564732068179852.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, hch@infradead.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On 01/27/2014 04:45 PM, FUJITA Tomonori wrote:
> On Sun, 26 Jan 2014 23:50:38 -0800
> Christoph Hellwig <hch@infradead.org> wrote:
>=20
>>>> Do you know if either SRP or ibmvscsi are used regularly these day=
s?
>>>> Does tgtd userspace still support this interface?
>>>
>>> It doesn't. I think that ibm pseries switched to virtual fc driver
>>> from virtual srp long ago. Only very old pseries could use the
>>> driver. I'm not sure there are any users of the driver. I guess tha=
t
>>> you could try to remove the driver to see if someone would complain=
=2E
>>
>> Should we try to throw in a deprecation warnings for this merge wind=
ow
>> and see if anyone cares, or go ahead and remove it entirely?
>=20
> Either is fine by me.

I actually know of a customer using this (with a semi-proprietary
target mode driver). I'll be asking him what his plans are.

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
