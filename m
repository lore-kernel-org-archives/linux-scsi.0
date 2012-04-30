From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH 4/6] qla4xxx: Add change_queue_depth API support
Date: Mon, 30 Apr 2012 04:32:58 -0700
Message-ID: <CBC475BF.E64F%vikas.chaudhary@qlogic.com>
References: <4F9ABE93.2060606@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:22124
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752266Ab2D3LdJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2012 07:33:09 -0400
In-Reply-To: <4F9ABE93.2060606@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Tej Parkash <tej.parkash@qlogic.com>



-----Original Message-----
From: Mike Christie <michaelc@cs.wisc.edu>
Date: Fri, 27 Apr 2012 08:43:15 -0700
To: Vikas <vikas.chaudhary@qlogic.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi
<linux-scsi@vger.kernel.org>, Lalit Chandivade
<lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Tej
Parkash <tej.parkash@qlogic.com>
Subject: Re: [PATCH 4/6] qla4xxx: Add change_queue_depth API support

>On 04/24/2012 12:32 AM, vikas.chaudhary@qlogic.com wrote:
>>
>> +static int qla4xxx_change_queue_depth(struct scsi_device *sdev, int
>>qdepth,
>> +                                  int reason)
>> +{
>> +    int queue_depth;
>> +    if (!ql4xqfulltracking)
>> +            return -EOPNOTSUPP;
>> +
>> +    queue_depth = iscsi_change_queue_depth(sdev, qdepth, reason);
>> +    return queue_depth;
>> +}
>> +
>
>No need for queue_depth. Just do
>
>return iscsi_change_queue_depth(sdev, qdepth, reason);

Thanks for the review.
updated patch is posted here:
http://marc.info/?l=linux-scsi&m=133578541226558&w=2



This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

