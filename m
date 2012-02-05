From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: sending ioctl warnings for a partition
Date: Sun, 05 Feb 2012 15:14:11 +0100
Message-ID: <4F2E8EB3.3010307@redhat.com>
References: <CANDSw5hvEwgCaXsk+OxBQ_xL+WiTLbTrVhB9H_W4NuU86bCNLQ@mail.gmail.com> <4F2D78D5.6050703@interlog.com> <4F2DBFAA.1040702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52001 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab2BEOOQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Feb 2012 09:14:16 -0500
Received: by eekc14 with SMTP id c14so1849211eek.19
        for <linux-scsi@vger.kernel.org>; Sun, 05 Feb 2012 06:14:14 -0800 (PST)
In-Reply-To: <4F2DBFAA.1040702@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, tdovera@gmail.com, zfs-fuse@sehe.nl

On 02/05/2012 12:30 AM, Paolo Bonzini wrote:
> That's correct.  zfs-fuse is trying to send a SYNCHRONIZE CACHE command,
> they should just use BLKFLSBUF (which will also give a warning due to a
> quirk in block/ioctl.c, but it's a false positive and the warning will
> go away soonish).

Not even that.  All that is needed is fsync.

Paolo
