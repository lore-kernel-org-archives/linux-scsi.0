From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: Megaraid corruption?
Date: Thu, 9 Dec 2004 09:18:55 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57057A1AF3@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:19639 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261397AbULIOTD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2004 09:19:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'res1uo0c@verizon.net'" <res1uo0c@verizon.net>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

We would need more details before speculating for the cause. What kind of
corruption is happening, mismatch data? How many bytes? Kernel messages when
the corruption is seen?

Thanks
-Atul Mukker 

> -----Original Message-----
> From: Troy Klein [mailto:res1uo0c@verizon.net] 
> Sent: Wednesday, December 08, 2004 9:18 PM
> To: linux-scsi@vger.kernel.org
> Subject: Megaraid corruption?
> 
> I am attempting to find out why I am having data corruption 
> problems on my megaraid2 driver and not on megaraid.  The 
> system is a 32-bit Xeon with a LSI 150-6 SATA controller 
> running Redhat EL 3.0AS.  When I am running megaraid I can 
> write data, read data, and modify data and get NO corruption. 
>  With megaraid2 I get data corruption with tar, rsync, and scp.
> 
> Can anyone help?
> 
> Troy Perplexed
> 
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> 
