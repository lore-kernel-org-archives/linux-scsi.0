From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 2/2] libata-scsi: do not response with "invalid field" for
 FORMAT UNIT
Date: Tue, 5 Jul 2016 00:31:57 +0300
Message-ID: <8d592104-be11-151f-a3e7-78e506879175@cogentembedded.com>
References: <20160704205335.5484-1-me>
 <577accda.46c0620a.65070.ffffec86@mx.google.com>
 <2c7e733e-a714-609e-d71e-9d5f4e81b44b@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:33973 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbcGDVcB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2016 17:32:01 -0400
Received: by mail-lf0-f46.google.com with SMTP id h129so123639696lfh.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jul 2016 14:32:00 -0700 (PDT)
In-Reply-To: <2c7e733e-a714-609e-d71e-9d5f4e81b44b@cogentembedded.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com, tj@kernel.org, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 07/05/2016 12:27 AM, Sergei Shtylyov wrote:

>> From: Tom Yan <tom.ty89@gmail.com>
>>
>> It does not make sense and is confusing to response with "Invalid
>
>    Respond here and in the subject.
>
>> field in cbd" while we have no support at all implemented for

    CDB.

>> FORMAT UNIT. It is decent to let it go to the default, which
>> will response with "Invalid command operation code" instead.
 >>

    Respond again.

>> Signed-off-by: Tom Yan <tom.ty89@gmail.com>

[...]

MBR, Sergei

