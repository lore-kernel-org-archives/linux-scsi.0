From: Grant Grundler <grundler@google.com>
Subject: Re: mptspi: Unexpected doorbell active!
Date: Wed, 8 Jul 2009 11:06:17 -0700
Message-ID: <da824cf30907081106q336ba116r525a5470c496450c@mail.gmail.com>
References: <4A54B611.2030802@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:32242 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbZGHSGV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2009 14:06:21 -0400
Received: from zps37.corp.google.com (zps37.corp.google.com [172.25.146.37])
	by smtp-out.google.com with ESMTP id n68I6JXx003867
	for <linux-scsi@vger.kernel.org>; Wed, 8 Jul 2009 11:06:19 -0700
Received: from qyk16 (qyk16.prod.google.com [10.241.83.144])
	by zps37.corp.google.com with ESMTP id n68I6Bxp023004
	for <linux-scsi@vger.kernel.org>; Wed, 8 Jul 2009 11:06:17 -0700
Received: by qyk16 with SMTP id 16so1634907qyk.27
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2009 11:06:17 -0700 (PDT)
In-Reply-To: <4A54B611.2030802@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

On Wed, Jul 8, 2009 at 8:06 AM, Douglas Gilbert<dgilbert@interlog.com> wrote:
> Cute error message but it appears just before my machine
> locks solid. It looks like it is coming from a LSI 53c1030
> SPI controller which lspci says is PCI-X but is actually
> PCIe.

It's probably not relevant to the problem, but I'm pretty sure 53c1030
SPI is a PCI-X device. I supported this driver for HP's IA64 (e.g
rx2600) machines starting around 2001 or 2002 (before PCIe was
available).  Can you dump the lspci output that claims this is a PCIe
device?

> I get that with 2 different tape drives (LTO-1 and LTO-3)
> whose true identities are hidden behind badge engineering,
> Tandberg data perhaps? Anyway both seem to have a major
> problem with the LOG SENSE command and the Tape Alert
> page in particular.
>
> The lockup occurs with both a Debian Lenny standard kernel
> (lk 2.6.26-2-686) and a kernel.org lk 2.6.30 .
>
> There is nothing other than the 53c1030 and a single tape
> drive on the SCSI bus. So there is no good reason to lock
> up the machine for any SCSI related error.

Other people have reported similar problems before:
    http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg14431.html

hth,
grant
