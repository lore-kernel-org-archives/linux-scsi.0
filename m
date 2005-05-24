From: Aldo Gavioli <aldo.gavioli@netstorage.it>
Subject: Re: sd driver
Date: Tue, 24 May 2005 14:21:13 +0200
Message-ID: <42931C39.5040904@netstorage.it>
References: <42919ABC.9030508@netstorage.it> <4292C7C4.2030204@torque.net>	 <429316D5.6050000@netstorage.it> <1116936165.6280.19.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout12.attiva.biz ([85.37.16.14]:8755 "EHLO
	smtpout12.attiva.biz") by vger.kernel.org with ESMTP
	id S262023AbVEXMVZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 08:21:25 -0400
In-Reply-To: <1116936165.6280.19.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>

Arjan,

>>We cannot denied to load different drivers than sd for type MOD.
>>    
>>
>
>why not? 
>  
>
because it seems that if sd driver attach the device as first one, other 
Upper Level Drivers  will not be called anymore from mid layer scsi.
And they will result not attached. Is this my fault or this is the real 
behaviour of kernel 2.6 ?

>>This behaviour will generate other troubles in developper community.
>>    
>>
>
>which community?
>  
>
Anyone is developping SCSI driver to pilot type MOD.

>again I asked you a question which you didn't bother to answer yet:
>Did you write your closed module with linux in mind or even specifically
>for linux? Because if so it *really* is better for everyone if you could
>show code on how to deal with your device instead, so that generic linux
>will work with it. (and it also avoids a big mess wrt GPL issues)
>  
>
Sorry for this. Here is my answer.
We are developping driver to be inserted in a software suite that will 
pilot optical drive with Write Once disk.
We have no problem to publish our driver source code.
In any case we think that could be not interesting  inserting in sd 
driver our private code and in case it will take very long time.
We are thinking about the best solution for this issue.

Thanks
Aldo

>
>
>  
>


-- 
Aldo Gavioli
Product Manager
NetStorage Software s.r.l
Viale Europa,74 - 20090 Cusago (Milan) Italy - Web: www.netstorage.it 


