From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] bfa: deinline __bfa_trc() and __bfa_trc32()
Date: Mon, 18 May 2015 05:58:35 -0700
Message-ID: <5559E1FB.2070004@roeck-us.net>
References: <1431940681-15915-1-git-send-email-dvlasenk@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:53898 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbbERM6k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2015 08:58:40 -0400
In-Reply-To: <1431940681-15915-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <dvlasenk@redhat.com>, Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: Fabian Frederick <fabf@skynet.be>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Christoph Hellwig <hch@lst.de>, Ben Hutchings <ben@decadent.org.uk>, James Bottomley <JBottomley@Parallels.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 05/18/2015 02:18 AM, Denys Vlasenko wrote:
> __bfa_trc() compiles to 115 bytes of machine code.
> With this .config: http://busybox.net/~vda/kernel_config
> there are 1494 calls of __bfa_trc().
>
> __bfa_trc32() is very similar, so it is uninlined too.
> However, it appears to be unused, therefore this patch
> ifdefs it out.
>
Why not just remove it ?

Guenter

