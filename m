From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: iscsi (?): Unknown VPD Code: 0xc7
Date: Fri, 24 Mar 2017 21:32:29 +0100
Message-ID: <5a83f853-3fcb-de44-20b3-89642e0eb477@gmail.com>
References: <6eb8196f-7116-6cd5-8039-25b9a956c19a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34773 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967587AbdCXUi5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2017 16:38:57 -0400
Received: by mail-wm0-f67.google.com with SMTP id u132so255067wmg.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2017 13:38:54 -0700 (PDT)
In-Reply-To: <6eb8196f-7116-6cd5-8039-25b9a956c19a@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harald Dunkel <harald.dunkel@aixigo.de>, Hannes Reinecke <hare@suse.de>, Brian King <brking@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 03/24/2017 09:16 PM, Xose Vazquez Perez wrote:

> Try to add "scsi_dev_flags=AIX:VDASD:0x10000000" to the kernel
> command line in grub.

# echo "AIX:VDASD:0x10000000" > /proc/scsi/device_info
should also work.
