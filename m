From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH block#for-2.6.31 2/3] block: set rq->resid_len to blk_rq_bytes()
 on issue
Date: Sat, 16 May 2009 22:48:29 +0900
Message-ID: <4A0EC42D.2080905@gmail.com>
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com> <4A0D8C73.50208@ru.mvista.com> <4A0DEA33.5050905@gmail.com> <4A0EB1AD.6050806@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f115.google.com ([209.85.222.115]:41674 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbZEPNsc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2009 09:48:32 -0400
In-Reply-To: <4A0EB1AD.6050806@ru.mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov <petkovbb@googlemail.com>, Pete Zaitcev <zaitcev@redhat.com>, Eric Moore <Eric.Moore@lsi.com>, "Darrick J. Wong" <djwong@us.ibm.com>

Hello, Sergei.

Sergei Shtylyov wrote:
>> Heh... there's a reason I mentioned the original commit.  The original
>> code was
>>
>>     if (ret > 0) {
>>         /* positive number is the untransferred residual */
>>         rsp->data_len = ret;
>>         req->data_len = 0;
>>         ret = 0;
>>     } else if (ret == 0) {
>>         rsp->data_len = 0;
>>         req->data_len = 0;
>>     }
>>   
> 
>   But still,
> 
>                req->data_len = 0;
> 
> is common between both branches, so could be moved after the *if*
> statement.

Yeah, sure, feel free to submit a patch, but I don't know.  Does it
even matter at all as long as the intention is clear?

Thanks.

-- 
tejun
