From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH 6/7] qla4xxx: Cleanup modinfo display
Date: Thu, 12 Jan 2012 04:57:03 -0800
Message-ID: <CB34D5CA.BC0F%vikas.chaudhary@qlogic.com>
References: <4F0E3EF0.7030106@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:45170
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752774Ab2ALM5O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2012 07:57:14 -0500
In-Reply-To: <4F0E3EF0.7030106@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>



On 12/01/12 7:31 AM, "Mike Christie" <michaelc@cs.wisc.edu> wrote:

>On 01/11/2012 04:44 AM, vikas.chaudhary@qlogic.com wrote:
>>
>> -int ql4xextended_error_logging = 0; /* 0 = off, 1 = log errors */
>> +int ql4xextended_error_logging = 0;
>
>You do not need to init this to 0 like above. It gets set to zero for
>you. I think this is some codingstyle doc rule violation. You should run
>checkpatch.pl on your patches before sending to catch this type of stuff.
>
>It is probably ok since it was there before and you are not adding it
>and your patch is focused on other stuff, but you should clean it up one
>day and make note of it for the future.

Yes, I will send separate cleanup patch for this type of codingstyle doc
rule violation.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

