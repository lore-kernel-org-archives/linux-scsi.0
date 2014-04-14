From: "Darius D." <darius.ski@gmail.com>
Subject: Re: HPSA related kernel panic on boot in 3.15 rc1 on Proliant with P420i
Date: Mon, 14 Apr 2014 15:30:21 +0300
Message-ID: <CAKt3ReJa9DoySNP81T=oq-F2W1NyDd_i1Xy+Tz-UAGEtUJ1WeA@mail.gmail.com>
References: <CAKt3ReJZ14+EAtDKxc6H=r3HCaVPbmX=6H8Rt6UjavkB45xOZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33289 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaDNMaW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Apr 2014 08:30:22 -0400
Received: by mail-pa0-f43.google.com with SMTP id bj1so8207159pad.30
        for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2014 05:30:22 -0700 (PDT)
In-Reply-To: <CAKt3ReJZ14+EAtDKxc6H=r3HCaVPbmX=6H8Rt6UjavkB45xOZw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

After minor googling found vga= option for kernel and managed to
capture full stack trace, like i suspected it is HPSA performant mode
related.

uploaded pic:

http://tinypic.com/r/2j68rwx/8

BR,

Darius.


On Mon, Apr 14, 2014 at 2:33 PM, Darius D. <darius.ski@gmail.com> wrote:
> Hi,
>
> on P420i (2GB FBWC) with latest(5.22?) FW, and 2 SSD smart path
> enabled RAID0 arrays (1 and 3 SSD), i get panic on initialization.
> What is sad, i can't capture complete stack trace and it is deep in
> kernel worker, but top items are:
>
> SA5_performant_intr_mask+0x30/0x30
> spin_unlock_irqrestore
> hpsa_unit_one
> local_pci_probe
> ... kthread worker stuff
>
>
> RIP is calc_bucket_map+0x30/0x3a.
>
>
> Anyone got idea what is going on? 3.14 was working fine with exact
> config, so i suspect it could be HPSA smart path code related.
>
>
> Best regards,
>
> Darius.
