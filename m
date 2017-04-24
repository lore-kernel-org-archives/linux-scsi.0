From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 1/9] sd: Remove white space before EOL
Date: Mon, 24 Apr 2017 09:14:50 +0900
Message-ID: <67a5b1f7-ce7b-664b-20f9-a90bef35f919@wdc.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
 <20170421091649.25287-2-damien.lemoal@wdc.com>
 <1492795349.2550.17.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:39201 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758693AbdDXAOy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Apr 2017 20:14:54 -0400
In-Reply-To: <1492795349.2550.17.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

Bart,

On 4/22/17 02:22, Bart Van Assche wrote:
> On Fri, 2017-04-21 at 18:16 +0900, damien.lemoal@wdc.com wrote:
>> No functional change is introduced by this patch.
> 
> Hello Damien,
> 
> The only tree for which I know that this kind of whitespace / coding style
> patches are welcome is the staging tree. In general such patches are not
> considered welcome because:
> - Such patches pollute the changelog and make it harder to use tools like
>   git annotate / git blame.
> - Such patches make it harder for distro maintainers to backport patches
>   from upstream kernels to distro (enterprise) kernels.
> - If any kernel developer has developed kernel patches for the sd driver
>   against kernel v4.11 and wants to submit these after the v4.12 merge
>   window then that developer will have to rebase (and retest) these
>   patches on top of kernel v4.12-rc1. Whitespace patches trigger really
>   ugly rebase conflicts and hence are painful for other kernel developers.
> 
> Hence my request to drop this patch.

OK. As I said, this patch was "optional".
Just wondering though how we are supposed to do code maintenance if that
kind of trivial cleanup cannot go in... (not to mention that checkpatch
keep warning about white spaces in sd.c if a patch touches something
near one of those multiple lines with white spaces).

But fine, let's drop it.

-- 
Damien Le Moal,
Western Digital
