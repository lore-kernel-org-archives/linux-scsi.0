From: "Milan P. Gandhi" <mgandhi@redhat.com>
Subject: Re: [PATCH] Remove white spaces from fcoe.h
Date: Mon, 5 Jun 2017 15:12:50 +0530
Message-ID: <d94f2aa7-8e5f-0117-d53b-31491b64b191@redhat.com>
References: <0f8b6a7b-c1d2-bc95-7970-7572991495cb@redhat.com>
 <alpine.DEB.2.20.1706051118090.2010@hadrien>
Reply-To: mgandhi@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34214 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751331AbdFEJmz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2017 05:42:55 -0400
Received: by mail-pf0-f170.google.com with SMTP id 9so80558303pfj.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jun 2017 02:42:55 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.20.1706051118090.2010@hadrien>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Johannes Thumshirn <jth@kernel.org>, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org

On 06/05/2017 02:48 PM, Julia Lawall wrote:
> 
> 
> On Mon, 5 Jun 2017, Milan P. Gandhi wrote:
> 
>> Remove the white spaces in do/while loop used for checking fcoe
>> debug logging
> 
> Is it converting spaces to tabs?  If so, saying that would be clearer.
yeah, it converts the white spaces to tabs.
> 
> julia
> 
>>
>> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
>> ---
>>  drivers/scsi/fcoe/fcoe.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
>> index 6aa4820..7406376 100644
>> --- a/drivers/scsi/fcoe/fcoe.h
>> +++ b/drivers/scsi/fcoe/fcoe.h
>> @@ -46,7 +46,7 @@ extern unsigned int fcoe_debug_logging;
>>  #define FCOE_NETDEV_LOGGING 0x02 /* Netdevice logging */
>>
>>  #define FCOE_CHECK_LOGGING(LEVEL, CMD)					\
>> -do {                                                            	\
>> +do {									\
>>  	if (unlikely(fcoe_debug_logging & LEVEL))			\
>>  		do {							\
>>  			CMD;						\
>> --
>> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
