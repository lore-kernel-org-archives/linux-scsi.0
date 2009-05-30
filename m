From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: next-20090522: kernel hungs at boot (async, libata/scsi)
Date: Sat, 30 May 2009 19:24:27 +0400
Message-ID: <a4423d670905300824qebe16d4r85c9276622b69677@mail.gmail.com>
References: <a4423d670905240443q75da19f7k210263fcb81297ae@mail.gmail.com>
	 <1243171419.2889.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1243171419.2889.4.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-next <linux-next@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

2009/5/24 James Bottomley <James.Bottomley@hansenpartnership.com>:
> This one's a strange one. =C2=A0It's entangled in the SCSI async conv=
ersion:
>
> commit 2c6dd125bace93f54d53f3e908f50db21733cbc9
> Author: Matthew Wilcox <matthew@wil.cx>
> Date: =C2=A0 Tue Apr 28 13:35:58 2009 -0600
>
> =C2=A0 =C2=A0[SCSI] Convert scsi_scan to use generic async mechanism
>
> I already reverted it for other reasons, so I think reverting it will
> make your problem go away. =C2=A0However, if your system only has ATA=
 ports
> and no SCSI ones, it shouldn't have got caught here. =C2=A0The SCSI a=
sync
> scan uses a separate run queue, which should be empty and thus it
> shouldn't be waiting here unless there's a problem inside the async
> scanning code.

Sorry, I was not able to respond.

20090529 boots fine.
