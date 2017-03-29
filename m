From: sonofagun@openmailbox.org
Subject: Re: Delock 89384 Sata Controller Causes Lockups Under Heavy Load
Date: Wed, 29 Mar 2017 16:43:02 +0300
Message-ID: <158d56db94baac238e35093d0223066b@openmailbox.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lb1.openmailbox.org ([5.79.108.160]:43558 "EHLO
        mail.openmailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753680AbdC2NnG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2017 09:43:06 -0400
Received: from www.openmailbox.org (unknown [10.0.0.4])
        by mail.openmailbox.org (Postfix) with ESMTP id 9D41A512148
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2017 15:43:02 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello there, I am new to this list too! Despite that, I think I can help 
you.

It is more likely that the issue is caused by the ASMedia controller or 
the disks. I have such a controller but it might not be the same 
revision.

If the controller is causing the lockup, I can try something but I will 
need more information to verify my thought. First of all send here the 
output of:
lspci -nn
and I will tell you later what else is needed.

If the disks are causing the lockup, I can tell you which one is the 
faulty disk(s). For each attached disk send the output of:
sudo smartctl -a /dev/sd*

I hope that your disks are fine as you will have a lot of job to do 
prior RMA if anyone is dying. It might be a good idea to find their 
receipts...
