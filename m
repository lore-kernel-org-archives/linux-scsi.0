From: "Alexander Stohr" <alexander.stohr@gmx.de>
Subject: Re: [BUG] Sym. 53c895 fails accessing tape device - kernel2.9.1-rc1-bk1 trough rc2-bk12
Date: Sun, 3 Oct 2004 11:07:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <00df01c4a928$7fd0e8c0$8511050a@alexs>
References: <13842.1096472870@www69.gmx.net><1096732158.2169.13.camel@mulgrave> <Pine.LNX.4.58.0410022246140.1977@kai.makisara.local> <1096756118.4415.39.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:13757 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267765AbUJCJIL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2004 05:08:11 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, matthew@wil.cx, akpm@digeo.com

what information would you need from me
to identify the bitness of the adapter and
the device so that i can see an advance
in my situation as well?

-Alex.

----- Original Message ----- 
From: "James Bottomley" <James.Bottomley@HansenPartnership.com>
To: "Kai Makisara" <Kai.Makisara@kolumbus.fi>
Cc: "Alexander Stohr" <Alexander.Stohr@gmx.de>; "SCSI Mailing List" <linux-scsi@vger.kernel.org>; <matthew@wil.cx>; <akpm@digeo.com>
Sent: Sunday, October 03, 2004 12:28 AM
Subject: Re: [BUG] Sym. 53c895 fails accessing tape device - kernel2.9.1-rc1-bk1 trough rc2-bk12


> On Sat, 2004-10-02 at 16:25, Kai Makisara wrote:
> > I would like to have a little more details. In order to see this message,
> > the tape drive should have been in fixed block mode. By default dd uses
> > write() size of 512 bytes. The size of linux-2.6.8.tar.gz is 44678561
> > bytes. This is not divisible by 512 and this means that the last write of
> > dd is not 512 bytes and the write fails in foxed block mode (it fails in
> > my tests). Could you give the exact command sequence leading to the error
> > and the result from 'mt status' before this sequence?>
> > Whatever I have tested now, I have not managed to get any messages from
> > sym53c8xx_2 (except the odd transfer error but that is transient).
>
> Well, I have to admit that I changed the tape (got HW errors) and
> everything's OK now.
>
> James
>
>

