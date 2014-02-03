From: Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Mon, 3 Feb 2014 22:24:14 +0100
Message-ID: <CAPXgP12a0tnyapaD90xVTqWg3BwE5H5SCqMhqgo_YVab7gCjKg@mail.gmail.com>
References: <1391157974-17512-1-git-send-email-hare@suse.de>
 <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de>
 <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi> <52EE2F2D.1010300@suse.de>
 <52EFACA4.6060001@tributary.com> <52EFB06C.8010101@suse.de>
 <52EFB0E7.3000504@tributary.com> <52F00717.5060106@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:53914 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaBCVYg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2014 16:24:36 -0500
Received: by mail-qc0-f178.google.com with SMTP id m20so12402879qcx.9
        for <linux-scsi@vger.kernel.org>; Mon, 03 Feb 2014 13:24:35 -0800 (PST)
In-Reply-To: <52F00717.5060106@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Jeremy Linton <jlinton@tributary.com>, Hannes Reinecke <hare@suse.de>, =?UTF-8?B?S2FpIE3DpGtpc2FyYSAoS29sdW1idXMp?= <kai.makisara@kolumbus.fi>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Feb 3, 2014 at 10:16 PM, Douglas Gilbert <dgilbert@interlog.com> wrote:
> On 14-02-03 10:08 AM, Jeremy Linton wrote:

>>         So whats wrong with the simple solution? You throw the ones for st
>> away, and
>> create the st handles from the nst worker.
>
>
> Doesn't seem to be any good solutions to this
> problem. If you can't discovery something without
> modifying its state, then what? For udev and/or
> sg_inq to know about the special relationship
> between st<i> nodes and nst<i> nodes seems
> unreasonable IMO.
>
> The cleanest way I can think of is for the st driver to
> show this relationship via sysfs. But then why should
> udev going mining for that relationship? A sysfs flag
> from the st driver indicating a node is "undiscoverable"
> might be a start.

Udev rules explicitely match on device names, that should be fine. It
can just not be included in the match if it does not provide the
needed functionality, or if it is not needed.

Kay
