From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] iscsi tcp: bidi capable
Date: Sun, 08 Feb 2009 12:00:20 +0200
Message-ID: <498EAD34.6040200@panasas.com>
References: <4975D96A.6020407@panasas.com> <498B6C0C.1070008@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:2934 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZBHKA2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Feb 2009 05:00:28 -0500
Received: by ug-out-1314.google.com with SMTP id 39so74848ugf.37
        for <linux-scsi@vger.kernel.org>; Sun, 08 Feb 2009 02:00:25 -0800 (PST)
In-Reply-To: <498B6C0C.1070008@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Pete Wyckoff <pw@padd.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Mike Christie wrote:
> Boaz Harrosh wrote:
>> From: Pete Wyckoff <pw@padd.com>
>>
>> Mark iscsi_tcp as being capable of bidirectional transfers.  The
>> bsg interface checks this bit before attempting any bidirectional
>> commands.
>>
>> Signed-off-by: Pete Wyckoff <pw@padd.com>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  drivers/scsi/iscsi_tcp.c |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
>> index af092a8..9e2d4fb 100644
>> --- a/drivers/scsi/iscsi_tcp.c
>> +++ b/drivers/scsi/iscsi_tcp.c
>> @@ -806,6 +806,12 @@ static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
>>  	iscsi_host_free(shost);
>>  }
>>  
>> +static int iscsi_tcp_slave_alloc(struct scsi_device *sdev)
>> +{
> 
> I merged this for 2.6.30 with a small change where this is renamed 
> iscsi_sw_tcp_slave_alloc to fit the naming of functions in that file.
> 

Sure, thanks, sorry. It's Pete's patch and I failed to adapt it to
latest changes.

> Thanks.
> 

Thanks
Boaz
