From: Eric Seppanen <eric@purestorage.com>
Subject: Re: mpt2sas losing reset events with cable pulls?
Date: Tue, 30 Aug 2011 20:16:04 -0700
Message-ID: <CADOQvuP=D3HLSnYNhtiTWC375YwzuXrnGaG=UdS0r8vmWm-A+Q@mail.gmail.com>
References: <1314751868-1112-1-git-send-email-roland@kernel.org>
	<4E5D9F4A.80009@interlog.com>
	<CAL1RGDU9QtuXGhMQN_cT6+RPh0NTZexYwE8HK1fpw5vuX_FLOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:47421 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751411Ab1HaDQF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2011 23:16:05 -0400
Received: by mail-gx0-f175.google.com with SMTP id 3so237555gxk.20
        for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2011 20:16:04 -0700 (PDT)
In-Reply-To: <CAL1RGDU9QtuXGhMQN_cT6+RPh0NTZexYwE8HK1fpw5vuX_FLOw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@lsi.com>, Eric Moore <eric.moore@lsi.com>

On Tue, Aug 30, 2011 at 7:47 PM, Roland Dreier <roland@kernel.org> wrot=
e:
> On Aug 30, 2011 7:41 PM, "Douglas Gilbert" <dgilbert@interlog.com> wr=
ote:
>> Most LSI HBA's based on the LSISAS2008 chip are now at
>> firmware version 10.00 . Perhaps you could retest with
>> that firmware.
>
> Eric S. can correct me if I'm wrong, but=A0 I'm pretty we've seen the=
 same
> issue with fw 10 as well.

Yes.  We've hit it on both version 9 and version 10.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
