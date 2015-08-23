From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [patch] qla4xxx: remove some bogus casts
Date: Sat, 22 Aug 2015 18:41:12 -0700
Message-ID: <55D924B8.3090407@sandisk.com>
References: <20150817143647.GA23820@mwanda> <55D2B879.7040906@sandisk.com>
 <20150818084726.GG5610@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0056.outbound.protection.outlook.com ([65.55.169.56]:18016
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751071AbbHWBlU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Aug 2015 21:41:20 -0400
In-Reply-To: <20150818084726.GG5610@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: QLogic-Storage-Upstream@qlogic.com, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On 08/18/15 01:47, Dan Carpenter wrote:
> On Mon, Aug 17, 2015 at 09:45:45PM -0700, Bart Van Assche wrote:
>> On 08/17/2015 07:36 AM, Dan Carpenter wrote:
>>> These casts are wrong and unnecessary.  They annoy static checkers
>>> because they imply we are planning to write sizeof(long) bytes to a
>>> sizeof(u32) buffer which would corrupt memory.
>>
>> Hello Dan,
>>
>> Can you verify whether that patch is still needed after having
>> applied the patch series I posted in July (and that was acknowledged
>> by QLogic): http://thread.gmane.org/gmane.linux.scsi/103135 ?
>>
>
> I think it is needed still?

Hello Dan,

You are right, this patch is indeed needed. Hence:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

