From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: mptfusion: how to Find a WWN of a logged in Fibre Channel	initiator?
Date: Wed, 25 Mar 2009 14:47:20 +0000
Message-ID: <49CA43F8.7000801@mpstor.com>
References: <49C78598.9090700@mpstor.com> <20090325142009.GA26612@mars.virtualiron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server009.hostspectrum.com ([206.123.101.24]:43192 "EHLO
	server009.hostspectrum.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645AbZCYOqh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 10:46:37 -0400
In-Reply-To: <20090325142009.GA26612@mars.virtualiron.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek <konrad@virtualiron.com>
Cc: linux-scsi@vger.kernel.org

Konrad Rzeszutek wrote:
> On Mon, Mar 23, 2009 at 12:50:32PM +0000, Benjamin ESTRABAUD wrote:
>   
>> Hi,
>>
>> I am wondering if anyone would know the answer to the following question:
>>
>> From the LSI mpt fusion driver, is there a way to extract the WWN of a 
>> logged in Fibre Channel initiator or a known SAS initiator? I can get its 
>> Initiator Index from the reply word... is there a way to use this to return 
>> the WWN from an internal table of logged on/known initiators?
>>     
>
> find /sys -name sas_address
> or
> find /sys -name port_name
>
> Doesn't help?
>
>   
Dear Konrad,

Thank you very much for your reply,

This command would help finding out the SAS addresses of any devices 
connected to the initiator, which would then work perfectly.

Unfortunately, I am working on a target configuration and trying to get 
the SAS address from a connected host.

The configuration would look like that:

Host(Initiator) <FC Link> - <FC Link> Target - <SAS> - <SAS> Disks.

I am trying to find the  WWN from the actual initiator host's FC card 
instead, from the Target.

Would you have more infos on how to do this?

Thanks in advance,

Ben - MPSTOR.
>> I've been trying for a good while now to do this but no luck whatsoever, I 
>> would really appreciate if someone who had an idea on how to do this could 
>> reply. Thanks a million in advance!
>>
>> Ben - MPSTOR.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>     
>
>   

