From: John Hughes <john@Calva.COM>
Subject: Re: ses enclosure stuff not working with Promise Vtrak J610S JBOD
Date: Wed, 04 Nov 2009 19:10:01 +0100
Message-ID: <4AF1C379.7060306@Calva.COM>
References: <4AF17AD3.6060909@Calva.COM>	 <1257348128.2697.29.camel@mulgrave.site>  <4AF1A38E.3000009@Calva.COM>	 <1257350834.2697.52.camel@mulgrave.site>  <4AF1A7E7.7070307@Calva.COM>	 <1257351654.2697.55.camel@mulgrave.site>  <4AF1C172.6080509@Calva.COM> <1257357948.10416.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oceanic.CalvaEDI.COM ([81.252.197.184]:37866 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbZKDSKA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2009 13:10:00 -0500
In-Reply-To: <1257357948.10416.9.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-11-04 at 19:01 +0100, John Hughes wrote:
>   
>>
>> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
>> index 55b034b..725a095 100644
>> --- a/drivers/scsi/ses.c
>> +++ b/drivers/scsi/ses.c
>> @@ -389,9 +389,9 @@ static void ses_enclosure_data_process(struct enclosure_devi
>>                 len = (desc_ptr[2] << 8) + desc_ptr[3];
>>                 /* skip past overall descriptor */
>>                 desc_ptr += len + 4;
>> -               if (ses_dev->page10)
>> -                       addl_desc_ptr = ses_dev->page10 + 8;
>>         }
>> +       if (ses_dev->page10)
>> +               addl_desc_ptr = ses_dev->page10 + 8;
>>     
>
> Ah, yes ... knew I'd done something stupid.
>
> Could you format this properly (as in with description) and add a signed
> off by line and I'll put it in the bug fixes tree.
>   
I'll do that tomorrow, off home to play some fallout3 now.

(Well, and feed the kids).
