From: Andrew Brooks <arb@sat.dundee.ac.uk>
Subject: Re: Tagged overlapped commands
Date: Wed, 17 Dec 2014 17:18:53 +0000
Message-ID: <CAHOfOo1pDc5DNSYX9-bWitFVbHX2Amw_qWtobS=hYWYua+gmmA@mail.gmail.com>
References: <CAHOfOo25V9Qqv=K7n5DnwDyN6TGBEzikMzhZ6OhF_2=+wG=bMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:44993 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaLQRTO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2014 12:19:14 -0500
Received: by mail-ie0-f170.google.com with SMTP id rd18so15512105iec.15
        for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2014 09:19:13 -0800 (PST)
In-Reply-To: <CAHOfOo25V9Qqv=K7n5DnwDyN6TGBEzikMzhZ6OhF_2=+wG=bMg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On 1 December 2014 at 12:22, Andrew Brooks <arb@sat.dundee.ac.uk> wrote:
> I'm having trouble writing to an LTO-5 tape drive connected via Adaptec 1405
> Writing aborts with this in syslog:
>
> st0: Sense Key : Aborted Command [current]
> st0: Add. Sense: Tagged overlapped commands (task tag 0)
>
> Both the drive and adapter have the latest firmware.
> I've tried ubuntu 12.04 (3.2.0-70) and the latest fedora 20.1.
>
> Does anyone have any ideas on how to troubleshoot and fix this?

I've tried the latest 3.18.0 kernel and tried setting the queue_depth to 1
but it still fails.

I've tried the mvsas driver and the adaptec open-source driver but both fail.
Maybe it's a fault in the underlying scsi driver?

Please could someone offer some assistance in helping me find the cause.

Thank you

Andrew
