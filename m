From: Libor Vanek <lvanek@terra.cz>
Subject: Re: [Iscsitarget-devel] Re: [ANNOUNCE] iSCSI enterprise target	software
Date: Tue, 01 Mar 2005 11:48:22 +0100
Message-ID: <42244876.9000204@terra.cz>
References: <1109666441.6293.62.camel@laptopd505.fenrus.org>	 <20050301183549J.fujita.tomonori@lab.ntt.co.jp>	 <1109670363.6293.70.camel@laptopd505.fenrus.org>	 <20050301192257C.fujita.tomonori@lab.ntt.co.jp> <1109673220.6293.78.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from ms.terra.cz ([212.71.159.130]:20237 "EHLO terra.cz")
	by vger.kernel.org with ESMTP id S261858AbVCAKsg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 05:48:36 -0500
Received: from [192.168.0.32] by terra.cz
	(MDaemon.PRO.v7.2.3.R)
	with ESMTP id md50000023831.msg
	for <linux-scsi@vger.kernel.org>; Tue, 01 Mar 2005 11:47:16 +0100
In-Reply-To: <1109673220.6293.78.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net

Arjan van de Ven wrote:

>On Tue, 2005-03-01 at 19:22 +0900, FUJITA Tomonori wrote:
>  
>
>>From: Arjan van de Ven <arjan@infradead.org>
>>Subject: [Iscsitarget-devel] Re: [ANNOUNCE] iSCSI enterprise target software
>>Date: Tue, 01 Mar 2005 10:46:03 +0100
>>
>>    
>>
>>>fsync or msync() ? I would imagine the target mmaping it's backend in
>>>userspace and using msync() to kick off IO. At which point it's not that
>>>much different from the control you do of the pagecache from inside the
>>>kernel...
>>>      
>>>
>>Can we avoid calling mmap() and munmap() repeatedly with large disk?
>>    
>>
>
>my server has 512Gb address space with 2.6.9/2.6.10, and a lot more than
>that with the 2.6.11 kernel (4 level page tables rock). So the answer
>would be yes.
>
>(and on old servers without 64 bit, you indeed need to mmap/munmap
>lazily to create a window, but I suspect that the 3 Gb of address space
>you have there can be managed smart to minimize the number of unmaps if
>you really try)
>  
>
I don't know in detail what are you talking about (if whole disk must 
fit address space) but please consider we're speaking about TBs (10-20 
TB RAID is quite cheap nowadays with 400 GB SATA disks).

-- 
Best regards,
Libor Vanek



