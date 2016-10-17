From: ojab <ojab@ojab.ru>
Subject: Re: `rmmod mpt3sas` leads to backtraces 'fs/sysfs/group.c:237
 sysfs_remove_group+0xa0/0xb0'
Date: Mon, 17 Oct 2016 21:11:05 +0000
Message-ID: <6ca446e0-07ba-e66a-2af5-e88c6fbacb0a@ojab.ru>
References: <d24894f9-5943-a962-6614-9a199e563dd1@ojab.ru>
 <20161017144218.r5wxpxk4oc4sdfe6@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:32771 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936212AbcJQVLK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 17:11:10 -0400
Received: by mail-lf0-f66.google.com with SMTP id l131so25854711lfl.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 14:11:09 -0700 (PDT)
In-Reply-To: <20161017144218.r5wxpxk4oc4sdfe6@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org

On 2016/10/17 14:42, Johannes Thumshirn wrote:
> On Sun, Oct 16, 2016 at 02:33:28PM +0000, ojab wrote:
>
> Hi Ojab,
>
> Do you have a known good kernel? If yes can you do a git bisect to see which
> commit introduces this?
>
> Thanks,
> 	Johannes
>

The issue is reproducible from the start, i. e. from commit

c84b06a48c4d8ac8270624453132f3fa1a4a0f9d mpt3sas: Single driver module
which supports both SAS 2.0 & SAS 3.0 HBAs

in which support for my HBA was added.
Before that the same issue can be reproduced using mpt2sas module in 
kernels >= 4.1.

Unfortunately earlier kernels fail to boot on my HW, so I can't 
investigate further.

//wbr ojab
