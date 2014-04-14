From: "Darius D." <darius.ski@gmail.com>
Subject: HPSA related kernel panic on boot in 3.15 rc1 on Proliant with P420i
Date: Mon, 14 Apr 2014 14:33:11 +0300
Message-ID: <CAKt3ReJZ14+EAtDKxc6H=r3HCaVPbmX=6H8Rt6UjavkB45xOZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:43510 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaDNLdM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Apr 2014 07:33:12 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so8109039pbb.22
        for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2014 04:33:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

on P420i (2GB FBWC) with latest(5.22?) FW, and 2 SSD smart path
enabled RAID0 arrays (1 and 3 SSD), i get panic on initialization.
What is sad, i can't capture complete stack trace and it is deep in
kernel worker, but top items are:

SA5_performant_intr_mask+0x30/0x30
spin_unlock_irqrestore
hpsa_unit_one
local_pci_probe
... kthread worker stuff


RIP is calc_bucket_map+0x30/0x3a.


Anyone got idea what is going on? 3.14 was working fine with exact
config, so i suspect it could be HPSA smart path code related.


Best regards,

Darius.
