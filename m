From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH 3/9] qla4xxx: fix call trace on rmmod with
 ql4xdontresethba=1
Date: Tue, 6 Dec 2011 02:46:03 -0800
Message-ID: <CB03EECB.B44B%vikas.chaudhary@qlogic.com>
References: <4ED9499E.5070707@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:6633 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751385Ab1LFKqO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Dec 2011 05:46:14 -0500
In-Reply-To: <4ED9499E.5070707@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Poornima Vonti <poornima.vonti@qlogic.com>, Sarang Radke <sarang.radke@qlogic.com>



On 03/12/11 3:26 AM, "Mike Christie" <michaelc@cs.wisc.edu> wrote:

>On 12/02/2011 12:42 AM, vikas.chaudhary@qlogic.com wrote:
>>
>>  /**
>> + * qla4xxx_is_eh_active:
>
>You need a description of the function above after the colon. And
>actually qla4xxx is doing a dash in other places. So you should do:
>
>/**
> * qla4xxx_is_eh_active - check if eh is rinning
>
>And just to make sure, if the host state is in SHOST_CANCEL_RECOVERY the
>drivers shutdown code will have cleaned up the command right? It looks
>like it, but I was not 100% sure.

I updated patch to take care of command cleanup on driver shutdown.
I am sending updated patch in next email.

Thanks,
Vikas.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

