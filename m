From: John Damm =?iso-8859-1?Q?S=F8rensen?= <john@hovedpuden.dk>
Subject: Re: /dev/[*]st* does not work with EXBAYTE 8505 with 2.6 kernels
Date: Wed, 25 Aug 2004 22:55:20 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <28477.192.48.171.17.1093467320.squirrel@192.48.171.17>
References: <412C315D.1000708@hovedpuden.dk>
    <Pine.LNX.4.58.0408252225550.1974@kai.makisara.local>
Reply-To: john@hovedpuden.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepa.post.tele.dk ([195.41.46.235]:27939 "EHLO
	pfepa.post.tele.dk") by vger.kernel.org with ESMTP id S268674AbUHYUz3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 16:55:29 -0400
In-Reply-To: <Pine.LNX.4.58.0408252225550.1974@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org


> I am moving this thread to linux-scsi where it belongs.
>
> On Wed, 25 Aug 2004, John Damm S=F8rensen wrote:
>
>> I have just upgraded from RH9 Linux 2.4 to FC2 Linux 2.6 and now my
>> EXABYTE 8505 no longer works.
>>
>> If I try to access it with mt (using any device like nst0) I get no =
such
>> device error message. Same thing with stinit.
>>
> This suggests that the st driver has not found your drive. Your tape =
drive
> is recognized as a sequential-access device and lsmod shows that st i=
s
> loaded. Puzzling.
>
> If you look at the kernel messages, do you see something like this:
>
> st: Version 20040403, fixed bufsize 32768, s/g segs 256
> Attached scsi tape st0 at scsi0, channel 0, id 5, lun 0
> st0: try direct i/o: yes (alignment 512 B), max page reachable by HBA
> 268435455

Yes, I see this message in dmesg.

>
> Another thing to check is /sys/class/scsi_tape/. You should see these
> files: nst0  nst0a  nst0l  nst0m  st0  st0a  st0l  st0m
>

These device files are also present.

> ...
>> Any hints?
>> Please don't tell me that the 8505 is no longer supported.
>>
> Any well-behaving drive is supported. I have used EXB8505 some years =
ago
> and I don't think this problem has anything to do with the drive.

I have also used this drive for a year or two now. Initially with 2.4 I
had problems with compression, but that was solved with new firmware th=
at
defaults to compression.

With 2.6 the tape  drive fails to work with the Qlogic HBA's ISP1040 (t=
he
HBA simply doesn't work with 2.6) and QLA12160, but it works with the
Symbios/LSI HBA.

/john
>
> --
> Kai
>


--=20
John Damm S=F8rensen, Stenkrogen 6, 2800 Kgs. Lyngby, +45 4498 6995

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
