From: Tape Help <tape.help@gmail.com>
Subject: Fwd: Multi tape problems with cpio
Date: Sat, 15 Jan 2005 02:32:22 -0500
Message-ID: <12c7da3e050114233249899ca1@mail.gmail.com>
References: <12c7da3e0501132353150d51f2@mail.gmail.com>
Reply-To: Tape Help <tape.help@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.194]:47951 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262235AbVAOHcY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Jan 2005 02:32:24 -0500
Received: by wproxy.gmail.com with SMTP id 40so974612wri
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jan 2005 23:32:22 -0800 (PST)
In-Reply-To: <12c7da3e0501132353150d51f2@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

No one on linux-tape has responded.  I think that list is dead.
Can anyone help?

Thanks.

---------- Forwarded message ----------
From: Tape Help <tape.help@gmail.com>
Date: Fri, 14 Jan 2005 02:53:16 -0500
Subject: Multi tape problems with cpio
To: linux-tape@vger.kernel.org


I am using cpio to backup a system.  The backup does not fit on 1
tape, so cpio prompts for another tape.  I change the tape and hit
enter.  cpio continues and completes.  cpio does eject the first tape,
which is handy.

When I try to list the tape, cpio gets an I/O error at the end of the
first tape and does not prompt for a second tape.  Same problem if I
try to restore data.

cpio: read error: Input/output error

I have tried 2 different tape drives.
Both give the same results.
I have done this test about 5 or so times.

The backup command:
find MyFS -depth|cpio -o --format=newc --block-size=128 -F /dev/st0

The command to list the tape(s):
cpio -i --only-verify-crc --list --block-size=128< /dev/st0

If I use dd to read the tape, it also gets a read error at the end.  I
think it should get an end of file and exit cleanly.

I am using kernel 2.4.28.  It also fails with 2.4.20-8.

Anyone have any ideas?

Sort of funny, at first only 1 tape was needed.  I tested that I could
restore from the tape and it worked.  It has been using 2 tapes for
over 6 months now.  I had no idea my backups have been bad for over
six months!  I can still restore from the first tape.

Thanks.
