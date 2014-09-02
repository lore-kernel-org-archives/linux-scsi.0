From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: Re: [PATCH 1/3] scsi/trace: Use macros for getting driver
 byte, host byte, msg byte, and status byte
Date: Tue, 02 Sep 2014 15:03:23 +0900
Message-ID: <54055DAB.2050103@hitachi.com>
References: <20140901123325.597.47231.stgit@yuno-kbuild.novalocal> <20140901123327.597.39622.stgit@yuno-kbuild.novalocal> <20140901151531.GA5136@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34084 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaIBGD0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Sep 2014 02:03:26 -0400
In-Reply-To: <20140901151531.GA5136@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, "Ewan D. Milne" <emilne@redhat.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

(2014/09/02 0:15), Christoph Hellwig wrote:
> On Mon, Sep 01, 2014 at 12:33:28PM +0000, Yoshihiro YUNOMAE wrote:
>> For getting driver byte, host byte, msg byte, and status byte, macros are
>> implemented in scsi/scsi.h, so we use it.
>
> As mentioned about three times in various previous scsi logging discussions
> this is entirely wrong and breaks decoding binary trace buffers.

No, this patch uses just macros, so this does not change decoders.
However, other patches change decoders in format files, so we need to
consider about these decoders more, as you say.
We'll discuss on https://lkml.org/lkml/2014/8/28/657.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


