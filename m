From: ojab <ojab@ojab.ru>
Subject: Re: `rmmod mpt3sas` leads to backtraces 'fs/sysfs/group.c:237
 sysfs_remove_group+0xa0/0xb0'
Date: Mon, 17 Oct 2016 08:40:54 +0000
Message-ID: <94a67af1-b9d5-2b7c-6e9a-6d0c3f66ff18@ojab.ru>
References: <d24894f9-5943-a962-6614-9a199e563dd1@ojab.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35005 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933019AbcJQIlI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 04:41:08 -0400
Received: by mail-lf0-f54.google.com with SMTP id l131so233125422lfl.2
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 01:40:58 -0700 (PDT)
In-Reply-To: <d24894f9-5943-a962-6614-9a199e563dd1@ojab.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org

On 2016/10/16 14:33, ojab wrote:
> Oh hai!
>
> I have LSI SAS 9217-8i HBA and `rmmod mpt3sas` leads to multiple
> backtraces if any disks are connected to the HBA.
> Reproducible on vanilla 4.7.5/4.8.1/4.9-rc1 kernels (haven't tested on
> another versions).
>
> Full output (4.9-rc1 kernel, 3*Seagate ST3000NM0023 drives are
> connected) is rather long and can be found here:
> https://gist.github.com/ojab/f21ff778a378e88b227a4253d683c6ca

…and also on boot I have an error than can be related to the backtrace:

 >…
 >[Sun Oct 16 18:46:12 2016]  sdd: sdd1
 >[Sun Oct 16 18:46:12 2016] sd 6:0:1:0: [sdd] Attached SCSI disk
 >[Sun Oct 16 18:46:12 2016] udevd[239]: error opening 
ATTR{/sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/host6/scsi_host/host6/link_power_management_policy} 
for writing: Permission denied
 >…

There is no such file in sysfs after boot completion.

//wbr ojab
