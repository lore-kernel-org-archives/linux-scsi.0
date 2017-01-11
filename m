From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [PATCH] drivers: block: Remove unnecessary cast
Date: Wed, 11 Jan 2017 17:44:08 -0600
Message-ID: <20170111174408.Horde.jhUrOBQ9W11ivhR3LHCArVC@gator4166.hostgator.com>
References: <20170111184105.GA10766@embeddedgus>
 <20170111200418.GA16314@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.123]:60755 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758973AbdALAEc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 19:04:32 -0500
Received: from cm6.websitewelcome.com (cm6.websitewelcome.com [108.167.139.19])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 84022C1267
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2017 17:44:09 -0600 (CST)
In-Reply-To: <20170111200418.GA16314@kroah.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: don.brace@microsemi.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Quoting Greg KH <gregkh@linuxfoundation.org>:

> On Wed, Jan 11, 2017 at 12:41:05PM -0600, Gustavo A. R. Silva wrote:
>> This issue was detected using Coccinelle and the following semantic patch:
>>
>> @@
>> expression * e;
>> expression arg1, arg2;
>> type T;
>> @@
>>
>> - e = (T *)
>> + e =
>> kmalloc(arg1, arg2);
>>
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>> ---
>>  drivers/block/cciss_scsi.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> Why send this to me?

Oops... Sorry... I was also working with the Staging tree, so it seems  
your e-mail address got in the middle at some point.

--
Gustavo A. R. Silva






