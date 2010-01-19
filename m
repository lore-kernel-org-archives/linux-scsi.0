From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH] SCSI/libsrp: fix bug in ADDITIONAL CDB LENGTH
	interpretation
Date: Tue, 19 Jan 2010 08:04:47 +0100
Message-ID: <e2e108261001182304x1f9be8arda2ae37905d6c8bb@mail.gmail.com>
References: <200912091952.19978.bart.vanassche@gmail.com>
	 <20091210083727O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41986 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab0ASHEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2010 02:04:51 -0500
Received: by ewy19 with SMTP id 19so1391565ewy.21
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jan 2010 23:04:49 -0800 (PST)
In-Reply-To: <20091210083727O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, brking@linux.vnet.ibm.com

On Thu, Dec 10, 2009 at 12:37 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
>
> On Wed, 9 Dec 2009 19:52:19 +0100
> Bart Van Assche <bart.vanassche@gmail.com> wrote:
>
> > Fix a bug in the interpretation of the ADDITIONAL CDB LENGTH (add_c=
db_len)
> > field of SRP_CMD requests. According to the SRP specification, the =
layout
> > of this single-byte field is as follows:
> > * Bits 0 and 1 are reserved.
> > * Bits 2 to 7 represent the ADDITIONAL CDB LENGTH field, symbolical=
ly
> > =A0 represented as n.
> > * Still according to the SRP specification, the ADDITIONAL CDB sect=
ion
> > =A0 takes 4*n bytes.
> >
> > Currently libsrp is only used by the ibmvscsi driver. Since the ibm=
vscsi
> > driver doesn't support large CDB's, this bug hasn't caused any prob=
lems yet.
> >
> > Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
> > Cc: James E.J. Bottomley <James.Bottomley@suse.de>
> > Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: Brian King <brking@linux.vnet.ibm.com>
>
> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Hello James,

In which kernel version will this patch be included ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
