From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Is this a known problem with the SCSI mid layer?
Date: Fri, 15 Jan 2010 12:50:26 -0500
Message-ID: <4B50AAE2.2000202@interlog.com>
References: <938826.85923.qm@web33005.mail.mud.yahoo.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53079 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab0AORuf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2010 12:50:35 -0500
In-Reply-To: <938826.85923.qm@web33005.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Cameron <smcameron@yahoo.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

Steve,
Could you confirm whether, in your environment, the scsi_debug
driver has the same problem.

Doug Gilbert


Stephen Cameron wrote:
> --- On Fri, 1/15/10, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> 
> ...
> 
>> Did you check that also after, say, several minutes? 
>> I suppose you
>> already looked at the kernel log for possibly related
>> messages and would
>> have reported them as well...  Nevertheless, I have
>> seen some cases of
>> device removal or driver removal where the SCSI layer spent
>> many minutes
>> (5? 15? I'm not sure anymore) in error handling although
>> the lower layer
>> had done its best (best but perhaps not well) to report the
>> device as
>> physically gone.
>>
>> Did you already test really long after device removal and
>> last close,
>> along the lines of this?
>> # while ((i++ < 20)); do rmmod $driver && break;
>> sleep 60; done
> 
> 
> I had left it sitting since last night (~6:00pm localtime), and this morning (~8:00am localtime), it still won't rmmod... so ~14 hours.
> 
> -- steve
> 
>> -- 
>> Stefan Richter
>> -=====-==-=- ---= -====
>> http://arcgraph.de/sr/
>>
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

