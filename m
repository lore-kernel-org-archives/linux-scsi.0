From: Andrew Brooks <arb@sat.dundee.ac.uk>
Subject: Tagged overlapped commands
Date: Mon, 1 Dec 2014 12:24:30 +0000
Message-ID: <CAHOfOo1WuW8MD=r1zEEfd+csNEWacQA4EYa95zhUn49MxbEEsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40945 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbaLAMYv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2014 07:24:51 -0500
Received: by mail-ie0-f173.google.com with SMTP id y20so9171631ier.4
        for <linux-scsi@vger.kernel.org>; Mon, 01 Dec 2014 04:24:51 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi

I'm having trouble writing to an LTO-5 tape drive connected via Adaptec 1405
Writing aborts with this in syslog:

st0: Sense Key : Aborted Command [current]
st0: Add. Sense: Tagged overlapped commands (task tag 0)

Both the drive and adapter have the latest firmware.
I've tried ubuntu 12.04 (3.2.0-70) and the latest fedora 20.1.

Does anyone have any ideas on how to troubleshoot and fix this?

Thanks

Andrew
