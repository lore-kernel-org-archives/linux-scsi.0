From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: Scsi Error handling query
Date: Thu, 26 Mar 2015 19:08:54 +0530
Message-ID: <5d00e10b067fd4d0fb82ecdec18dd325@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:33079 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbbCZNi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2015 09:38:56 -0400
Received: by labto5 with SMTP id to5so45822569lab.0
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2015 06:38:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, linux-scsi@vger.kernel.org

Hi Hannes,

I was going through one of the slide posted at below link.

http://events.linuxfoundation.org/sites/events/files/slides/SCSI-EH.pdf

Slide #59 has below data. I was trying to correlate with latest upstrea=
m
code, but do not understand few things. Does Linux handle blocking I/O =
to
the device and target before it actually start legacy EH recovery ? Als=
o,
how does linux scsi stack achieve task set abort ?

Proposed SCSI EH strategy
=E2=80=A2 Send command aborts after timeout
=E2=80=A2 EH Recovery starts:
=E2=80=92 Block I/O to the device
       =E2=80=92 Issue 'Task Set Abort'
=E2=80=92 Block I/O to the target
       =E2=80=92 Issue I_T Nexus Reset
       =E2=80=92 Complete outstanding command on success
=E2=80=92 Engage current EH strategy
       =E2=80=92 LUN Reset, Target Reset etc


Thanks, Kashyap
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
