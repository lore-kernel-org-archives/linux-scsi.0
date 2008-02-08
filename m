From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Fri, 08 Feb 2008 13:32:07 +0300
Message-ID: <47AC2FA7.7020700@vlnb.net>
References: <393719.81864.qm@web31808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:54892 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760884AbYBHKcG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 05:32:06 -0500
In-Reply-To: <393719.81864.qm@web31808.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ming Zhang <blackmagic02881@gmail.com>

Luben Tuikov wrote:
> Is there an open iSCSI Target implementation which does NOT
> issue commands to sub-target devices via the SCSI mid-layer, but
> bypasses it completely?

What do you mean? To call directly low level backstorage SCSI drivers 
queuecommand() routine? What are advantages of it?

>    Luben
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

