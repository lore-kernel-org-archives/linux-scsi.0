From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: [PATCH] SCSI midlayer power management
Date: Wed, 11 Aug 2004 08:55:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <411A1744.4020100@optonline.net>
References: <411960C3.5090107@optonline.net>
 <1092218000.18968.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta9.srv.hcvlny.cv.net ([167.206.5.42]:58451 "EHLO
	mta9.srv.hcvlny.cv.net") by vger.kernel.org with ESMTP
	id S268048AbUHKMzd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Aug 2004 08:55:33 -0400
In-reply-to: <1092218000.18968.2.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: 'James Bottomley' <James.Bottomley@steeleye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, jgarzik@pobox.com

Alan Cox wrote:

>On Mer, 2004-08-11 at 00:56, Nathan Bryant wrote:
>  
>
>>This might help SATA drives, too, but I seem to remember that the SATA 
>>layer doesn't properly emulate the SYNCHRONIZE_CACHE command.
>>    
>>
>
>That was something Mark Lord reported higher level I suspect - which is
>that the scsi path is disabled before the sync cache command is sent so
>the command is always errored before it hits the drive
>  
>
That applies to shutdown, I have no idea whether it also applies to suspend.

Thanks
Nathan
