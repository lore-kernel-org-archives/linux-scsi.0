From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v3 4/5] target: Use scsi helpers to build the sense data
 correctly
Date: Wed, 8 Jul 2015 13:23:45 +0300
Message-ID: <559CFA31.4060703@dev.mellanox.co.il>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
 <1436188508-1539-5-git-send-email-sagig@mellanox.com>
 <20150708101738.GC14466@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34990 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862AbbGHKXe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2015 06:23:34 -0400
Received: by wgjx7 with SMTP id x7so191379461wgj.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2015 03:23:32 -0700 (PDT)
In-Reply-To: <20150708101738.GC14466@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

On 7/8/2015 1:17 PM, Christoph Hellwig wrote:
>> --- a/include/target/target_core_base.h
>> +++ b/include/target/target_core_base.h
>> @@ -7,6 +7,7 @@
>>   #include <linux/blkdev.h>
>>   #include <linux/percpu_ida.h>
>>   #include <linux/t10-pi.h>
>> +#include <scsi/scsi_common.h>
>>   #include <net/sock.h>
>>   #include <net/tcp.h>
>
> Please only add the include in the files that need it.  (And many of the
> existing includes should be fixed up the same way, but that's a
> different story).
>

OK, I'll move it.
