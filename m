From: Steven Dake <sdake@mvista.com>
Subject: Re: An array failover driver
Date: Thu, 19 Dec 2002 15:17:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E02455C.9010305@mvista.com>
References: <EB1DF7EA0D32D611B79C0002A51363F194A7BE@exw-ks.ks.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "Qi, Yanling" <yqi@lsil.com>
Cc: 'linux-scsi-reflector' <linux-scsi@vger.kernel.org>

There is a failover driver as part of the MD driver system.  I think 
someone has worked on a SCSI multipathing driver that automatically 
picks up redundant paths and fails over on retries, etc.

-steve

Qi, Yanling wrote:

>Hi All, 
>
>I am going to develop a multiple-pathing driver to support our storage array
>hardware on Linux(2.4 and later). I prefer the driver sit on the top of HBA
>drivers (fibre channel adapter drivers) and below middle level (the unifying
>layer). In other words, insert my pseudo driver into middle level and lower
>level drivers. The driver will take care of path failover. I am still in
>research phase. Do you have any suggestions?
>
>  
>Thanks, 
>  
>Yanling Qi 
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>  
>

