From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Sat, 6 Dec 2008 22:41:34 +0100
Message-ID: <200812062241.35601.bzolnier@gmail.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp> <200812061551.08525.bzolnier@gmail.com> <20081206120001.3580b9e3@tuna>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:9933 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbYLFVmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Dec 2008 16:42:36 -0500
Received: by fg-out-1718.google.com with SMTP id 19so381572fgg.17
        for <linux-scsi@vger.kernel.org>; Sat, 06 Dec 2008 13:42:34 -0800 (PST)
In-Reply-To: <20081206120001.3580b9e3@tuna>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan =?utf-8?q?No=C3=A9?= <dpn@isomerica.net>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org

On Saturday 06 December 2008, Dan No=C3=A9 wrote:
> On Sat, 6 Dec 2008 15:51:08 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>=20
> > PS If somebody wants to work on OSST support for IDE we can provide=
 an
> > assistance into porting osst.c over generic ATAPI code -- it would
> > still be much less hassle than trying to figure out remaining
> > ide-scsi issues (lifetime rules for IDE / SCSI / IDE-SCSI objects,
> > error handling etc.). --
>=20
> I wouldn't mind doing this - I was a user of an IDE OnStream for many
> years but alas my drive died years ago and OnStream is out of
> business.  If someone had a drive to offer maybe it could be done.

It would be great but it seems like IDE OnStream drives are a real rari=
ty
nowadays (unfortunately I won't be of a much help here, don't have any)=
=2E..

I think that for the time being it is best to just proceed with the rem=
oval
and see if there are any users needing the driver (+ we should probably=
 try
SCSI/libata/osst path first).

Thanks,
Bart
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
