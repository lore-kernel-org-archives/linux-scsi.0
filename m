From: "Amit D. Chaudhary" <amit_c@comcast.net>
Subject: Re: SCSI_IOCTL_GET_IDLUN
Date: Wed, 12 May 2004 15:53:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40A2AAF4.5010805@comcast.net>
References: <OFEC3573DC.7085A76C-ON07256E92.00606938-07256E92.00606ED8@az05.bull.com> <40A27C2E.6040205@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:6358 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S263032AbUELWzo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 May 2004 18:55:44 -0400
In-Reply-To: <40A27C2E.6040205@comcast.net>
List-Id: linux-scsi@vger.kernel.org
To: Jim.Roarick@Bull.com
Cc: linux-scsi@vger.kernel.org

Jim,

One more thing, there is already a patch pending for this, incase you 
want to use it by Doug Gilbert which was posted to linux-scsi on 
4/25/2004, search for subject "[PATCH] st.c for GET_IDLUN 2.6.6-rc2".

Amit

Amit D. Chaudhary wrote:
> Jim,
> 
> It seems like the problem is due to an addition in 2.6.5 to
> drivers/scsi/st.c, st_ioctl() function to make a call scsi_cmd_ioctl() 
> which is in drivers/block/scsi_ioctl() before making a call to scsi_ioctl()
> 
> scsi_cmd_ioctl() does put a 0 instead of proper data for 
> SCSI_IOCTL_GET_IDLUN, SCSI_IOCTL_GET_BUS_NUMBER, etc.
> 
> Let's wait for a day or so to see if someone else responds that there is 
> might be a work in progress.
> 
> Amit
> 
> 
> Jim.Roarick@Bull.com wrote:
> 
>> We have an application that does an open of a pseudo tape device ( 
>> /dev/st(x) ), followed by an ioctl (SCSI_IOCTL_GET_IDLUN) to get the 
>> address information. This worked fine in 2.4.6-20 and 2.6.1 but in 
>> 2.6.5 returns null with no error indicated.
>>
>> Did something change in mid-stream and, if so, how does one make it 
>> work again?
>>
>> Sorry for the lack of a low level description, I am neither a kernel 
>> person or a driver person, merely an application person.
>>
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
