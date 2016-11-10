From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Delivery Status Notification for linuxraid@lsi.com
Date: Thu, 10 Nov 2016 14:23:01 +0100
Message-ID: <c8571e44-4587-705e-9d48-da62b3312c0c@molgen.mpg.de>
References: <047d7b66fd9d4090c40540dd252b@google.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------DD9A39D0F577B3D1E445BCD2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.molgen.mpg.de ([141.14.17.9]:35145 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932336AbcKJNXJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Nov 2016 08:23:09 -0500
In-Reply-To: <047d7b66fd9d4090c40540dd252b@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

This is a multi-part message in MIME format.
--------------DD9A39D0F577B3D1E445BCD2
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Linux folks,


Probably you know it already, but the listed email address of the 3WARE 
SCSI drivers maintainer linuxraid@lsi.com doesn’t work (for me).

Please see the attached message.


Kind regards,

Paul

--------------DD9A39D0F577B3D1E445BCD2
Content-Type: message/rfc822;
 name="Attached Message"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Attached Message"

Return-Path: <>
Received: from mx.molgen.mpg.de (mx.molgen.mpg.de [141.14.17.8])
	 by rofl.molgen.mpg.de (Cyrus 2.5.3) with LMTPA;
	 Wed, 09 Nov 2016 12:38:34 +0100
X-Sieve: CMU Sieve 2.4
Received: from mfilter-124-1-1.mx.srv.dfn.de (mfilter-124-1-1.mx.srv.dfn.de [194.95.232.62])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.molgen.mpg.de (Postfix) with ESMTPS id 0F3A5201299B58
	for <pmenzel@molgen.mpg.de>; Wed,  9 Nov 2016 12:38:34 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mfilter-124-1-1.mx.srv.dfn.de (Postfix) with ESMTP id 1520DE00D8
	for <pmenzel@molgen.mpg.de>; Wed,  9 Nov 2016 12:38:34 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at mgw1-han.srv.dfn.de
Received: from mfilter-124-1-1.mx.srv.dfn.de ([127.0.0.1])
	by localhost (mgw1-han.srv.dfn.de [127.0.0.1]) (amavisd-new, port 20030)
	with ESMTP id Pv7VN1xZp0-d for <pmenzel@molgen.mpg.de>;
	Wed,  9 Nov 2016 12:38:33 +0100 (CET)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
	by mfilter-124-1-1.mx.srv.dfn.de (Postfix) with ESMTPS
	for <pmenzel@molgen.mpg.de>; Wed,  9 Nov 2016 12:38:33 +0100 (CET)
Received: by mail-wm0-f68.google.com with SMTP id a20so17861375wme.2
        for <pmenzel@molgen.mpg.de>; Wed, 09 Nov 2016 03:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20120113;
        h=mime-version:from:to:auto-submitted:subject:references:in-reply-to
         :message-id:date:content-transfer-encoding;
        bh=VvT0UxkZSKGQ5ZCdycVVGCivpdcGk86c9JQftvyzUoU=;
        b=hWW7htTTCy22pWXBaerqQfw3vgZXTcUbQzx4yHNfhGbR8KagQWVh/ZUcBtaptEb54Y
         xNeD6fHNgl+Ss1Axm/TK2x+TA245ZcXVpa8GEf2tMB0YzLeCicuVPv0qIqLzikHGGj+S
         HXWPzZY17IANotfNiuhbWJbrgOO61ZYCNJs3KY8QcrR6UpuWtehUaTjxF2Mpdpkz6Gw4
         OSCYxLXOQNg4LeTswS2BJAG/NppEN/Sf0YFiXUGa991MdazOyVCvMSiDJ6Gn3+GrDj2j
         JdkyoZ/VDmib94XxPlEvGakBP+pZBx8SJZ8Fn9YYNxKNYExdIAK9kKra4nEOrY6UQxjd
         5unA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20130820;
        h=x-gm-message-state:mime-version:from:to:auto-submitted:subject
         :references:in-reply-to:message-id:date:content-transfer-encoding;
        bh=VvT0UxkZSKGQ5ZCdycVVGCivpdcGk86c9JQftvyzUoU=;
        b=PECoufUPajbLeJJ8MA1k58J717O01ioMYEG8UyWjL8UilmBfi+99S+ZfftLaBwijKG
         0eYG08RuXTyDd4qCm2Z9KLsedSX9MI8/WN1Lbwzt2KOFGtRiI3ZudzPMxi+RixS1wNbd
         COqAaI7BqlJWbFyvL4gHs3mZsEs61Mziq1x9/3l6sMH5pCAX0ACkjKXhjdMdl+3xry9L
         HlzKfe3XpDlRCpWDJ5qJtw8ItJhi+LrZdPHgTHioOYWJI/g+O65wnFtthErLwHClvBoT
         asA266FizlS8VQc8ncyFtl5zKMxr/9mlZ8Qel92SQda7F3s6voB9XztkosbOtLz0xalp
         7MPw==
X-Gm-Message-State: ABUngveSWn5v+f04NqrhcSyR506p1mWN83OSp47QiquwB9iQ/ghh7aBzIUuDJPv/enHXiQnfAFWkPZaOYS9ZHoFsVBa3+1zm
X-Received: by 10.28.209.67 with SMTP id i64mr19609145wmg.48.1478691507813;
        Wed, 09 Nov 2016 03:38:27 -0800 (PST)
MIME-Version: 1.0
Received: by 10.28.209.67 with SMTP id i64mr20968242wmg.48; Wed, 09 Nov 2016
 03:38:27 -0800 (PST)
From: Mail Delivery Subsystem <mailer-daemon@googlemail.com>
To: pmenzel@molgen.mpg.de
Auto-Submitted: auto-replied
Subject: Delivery Status Notification (Delay)
References: <a41b4bab-edb7-34ab-eb76-7ff4d6e3f677@molgen.mpg.de>
In-Reply-To: <a41b4bab-edb7-34ab-eb76-7ff4d6e3f677@molgen.mpg.de>
Message-ID: <94eb2c12fffc0e3a880540dcb2e7@google.com>
Date: Wed, 09 Nov 2016 11:38:27 +0000
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This is an automatically generated Delivery Status Notification

THIS IS A WARNING MESSAGE ONLY.

YOU DO NOT NEED TO RESEND YOUR MESSAGE.

Delivery to the following recipient has been delayed:

     linuxraid@lsi.com

Message will be retried for 5 more day(s)

Technical details of temporary failure:=20
The recipient server did not accept our requests to connect. Learn more at =
https://support.google.com/mail/answer/7720=20
[192.19.192.224 192.19.192.224: timed out]

----- Original message -----

X-Gm-Message-State: ABUngveFBksx92G0BZX5qMdBuCDHDG4xuI0c1GPn8OQmdZmNS3ZMR9/=
TFIpcevk2OOorMUNMld3vQugDvWxMGFOcWZveSLRhDyWLWqRReAKzrCIwHLeIr+9x3z44bqKAnr=
2A3oQ=3D
X-Received: by 10.28.209.67 with SMTP id i64mr12975034wmg.48.1478599659285;
        Tue, 08 Nov 2016 02:07:39 -0800 (PST)
X-Received: by 10.28.209.67 with SMTP id i64mr12975009wmg.48.1478599659097;
        Tue, 08 Nov 2016 02:07:39 -0800 (PST)
Return-Path: <pmenzel@molgen.mpg.de>
Received: from mx1.molgen.mpg.de (mx1.molgen.mpg.de. [141.14.17.9])
        by mx.google.com with ESMTPS id w203si15677261wmg.41.2016.11.08.02.=
07.38
        for <linuxraid@lsi.com>
        (version=3DTLS1_2 cipher=3DECDHE-RSA-AES128-GCM-SHA256 bits=3D128/1=
28);
        Tue, 08 Nov 2016 02:07:38 -0800 (PST)
Received-SPF: pass (google.com: domain of pmenzel@molgen.mpg.de designates =
141.14.17.9 as permitted sender) client-ip=3D141.14.17.9;
Authentication-Results: mx.google.com;
       spf=3Dpass (google.com: domain of pmenzel@molgen.mpg.de designates 1=
41.14.17.9 as permitted sender) smtp.mailfrom=3Dpmenzel@molgen.mpg.de
Received: from keineahnung.molgen.mpg.de (keineahnung.molgen.mpg.de [141.14=
.17.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 08BAC20128247D;
	Tue,  8 Nov 2016 11:07:38 +0100 (CET)
To: linux-scsi@vger.kernel.org
Cc: Adam Radford <linuxraid@lsi.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Ordering problems with 3ware controller
Message-ID: <a41b4bab-edb7-34ab-eb76-7ff4d6e3f677@molgen.mpg.de>
Date: Tue, 8 Nov 2016 11:07:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=3Dutf-8; format=3Dflowed
Content-Transfer-Encoding: 8bit
X-Gm-Spam: 0
X-Gm-Phishy: 0

Dear Linux SCSI folks,


Updating from Linux 4.4.X to Linux 4.8.4, we noticed that the 3ware=20
devices under `/dev` =E2=80=93 `/dev/twa0`, `/dev/twa1`, =E2=80=A6 =E2=80=
=93 map to the=20
controllers differently.

This unfortunately breaks quite a lot of our scripts, as we depend on=20
the fact that the first controller is also in the front.

> $ dmesg | grep 3ware
> [   14.509238] 3ware 9000 Storage Controller device driver for Linux v2.2=
6.02.014.
> [   14.824274] scsi host8: 3ware 9000 Storage Controller
> [   14.824537] 3w-9xxx: scsi8: Found a 3ware 9000 Storage Controller at 0=
xd0200000, IRQ: 17.
> [   15.508310] scsi host9: 3ware 9000 Storage Controller
> [   15.508569] 3w-9xxx: scsi9: Found a 3ware 9000 Storage Controller at 0=
xda100000, IRQ: 17.

Tracing `twi_cli` it looks like the ordering of the devices in=20
`/sys/class/scsi_host` might have changed, as `getdents64` seems to be=20
used for the ordering of creating `/dev/twaX`.

> $ find /sys/class/scsi_host/ -ls
>      6033      0 drwxr-xr-x   2  root     system          0 Nov  8 10:58 =
/sys/class/scsi_host/
>     23125      0 lrwxrwxrwx   1  root     system          0 Oct 27 17:41 =
/sys/class/scsi_host/host0 -> ../../devices/pci0000:00/0000:00:07.0/ata1/ho=
st0/scsi_host/host0
>     29893      0 lrwxrwxrwx   1  root     system          0 Oct 27 18:03 =
/sys/class/scsi_host/host9 -> ../../devices/pci0000:80/0000:80:0e.0/0000:90=
:00.0/host9/scsi_host/host9
>     23878      0 lrwxrwxrwx   1  root     system          0 Oct 27 17:41 =
/sys/class/scsi_host/host7 -> ../../devices/pci0000:80/0000:80:08.0/ata8/ho=
st7/scsi_host/host7
>     23640      0 lrwxrwxrwx   1  root     system          0 Oct 27 17:41 =
/sys/class/scsi_host/host5 -> ../../devices/pci0000:80/0000:80:07.0/ata6/ho=
st5/scsi_host/host5
>     23402      0 lrwxrwxrwx   1  root     system          0 Oct 27 17:41 =
/sys/class/scsi_host/host3 -> ../../devices/pci0000:00/0000:00:08.0/ata4/ho=
st3/scsi_host/host3
>     23164      0 lrwxrwxrwx   1  root     system          0 Oct 27 17:41 =
/sys/class/scsi_host/host1 -> ../.

----- Message truncated -----


--------------DD9A39D0F577B3D1E445BCD2--
