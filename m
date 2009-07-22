From: rohan a <info1686@gmail.com>
Subject: Re: SCSI command (SP-OUT) failing on SLES 9 32-bit
Date: Wed, 22 Jul 2009 18:56:22 +0530
Message-ID: <7a7c22420907220626t11f510b7q835add0d5b7ecc94@mail.gmail.com>
References: <7a7c22420907142137o4253dfb5gcd72176cd6a38beb@mail.gmail.com>
	 <7a7c22420907142326t3b8d4f5fqaf3813cb456186ec@mail.gmail.com>
	 <7a7c22420907150803v4f4ae9dn9eff41b5d5a7edf6@mail.gmail.com>
	 <1247670563.4236.16.camel@mulgrave.site> <4A645FCE.5030506@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:44001 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbZGVN0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2009 09:26:24 -0400
In-Reply-To: <4A645FCE.5030506@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,
       Thanks for a reply.
I have 2 SLES 9 32-bit machines, on one I am using an FC HBA card and
another a SCSI HBA card to connect LTO-4 standalone drives and drive
based encryption is not working in both cases.

Thanks

On Mon, Jul 20, 2009 at 5:45 PM, Hannes Reinecke<hare@suse.de> wrote:
> James Bottomley wrote:
>> On Wed, 2009-07-15 at 20:33 +0530, rohan a wrote:
>>> Hi guys,
>>>
>>> Any suggestions...please help
>>
>> I know of no kernel bug that could be causing this. =A0The SLES9 ker=
nel is
>> just too old though for me to remember clearly. =A0I'd suggest you f=
ile a
>> support incident with SUSE ... they'll debug and fix this on the old=
er
>> kernels; we really only deal with the new kernel and one or two back
>> revisions here on linux-scsi.
>>
> You did that on purpose.
> The 'they' is actually me :-(
>
> Actually, there already _is_ a bug, so no need to open another one.
> Which HBA are you using?
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 zSeries & Sto=
rage
> hare@suse.de =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+49 9=
11 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
