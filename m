From: Tullio Dovera <tdovera@gmail.com>
Subject: Re: sending ioctl warnings for a partition
Date: Tue, 7 Feb 2012 17:34:58 +0100
Message-ID: <CANDSw5jRWmTKfqwMqSnEBEHmE-Q6FH1cDwupVfHCxXrkBB8xcQ@mail.gmail.com>
References: <CANDSw5hvEwgCaXsk+OxBQ_xL+WiTLbTrVhB9H_W4NuU86bCNLQ@mail.gmail.com>
	<4F2D78D5.6050703@interlog.com>
	<4F2DBFAA.1040702@redhat.com>
	<4F2E8EB3.3010307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35015 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2BGQe7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2012 11:34:59 -0500
Received: by iacb35 with SMTP id b35so10328323iac.19
        for <linux-scsi@vger.kernel.org>; Tue, 07 Feb 2012 08:34:58 -0800 (PST)
In-Reply-To: <4F2E8EB3.3010307@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, zfs-fuse@sehe.nl

Thank you very much. I have opened an issue in zfs-fuse project.

Tullio

On Sun, Feb 5, 2012 at 3:14 PM, Paolo Bonzini <pbonzini@redhat.com> wro=
te:
> On 02/05/2012 12:30 AM, Paolo Bonzini wrote:
>>
>> That's correct. =A0zfs-fuse is trying to send a SYNCHRONIZE CACHE co=
mmand,
>> they should just use BLKFLSBUF (which will also give a warning due t=
o a
>> quirk in block/ioctl.c, but it's a false positive and the warning wi=
ll
>> go away soonish).
>
>
> Not even that. =A0All that is needed is fsync.
>
> Paolo
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
