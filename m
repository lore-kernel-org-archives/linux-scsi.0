From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Wed, 02 Mar 2005 13:47:26 +0300
Message-ID: <422599BE.9020008@vlnb.net>
References: <OF551AE89E.73361D54-ON88256FB7.00720071-88256FB7.0072B239@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from smtpout.azz.ru ([81.176.69.27]:31682 "HELO mailserver.azz.ru")
	by vger.kernel.org with SMTP id S262257AbVCBKof (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2005 05:44:35 -0500
In-Reply-To: <OF551AE89E.73361D54-ON88256FB7.00720071-88256FB7.0072B239@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, iscsitarget-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Bryan Henderson wrote:
>>You want to *use* the kernel pagecache as much as you can.
> 
> 
> No, I really don't.  Not always.  I can think of only 2 reasons to 
> maximize my use of the kernel pagecache: 1) saves me duplicating code; 2) 
> allows me to share resources (memory and disk bandwidth come to mind) with 
> others in the same Linux system fairly.  There are many cases where those 
> two benefits are outweighed by the benefits of using some other cache.  If 
> you're thinking of other benefits of using the pagecache, let's hear them.

You forgot the third reason (benefit), though it doesn't directly 
related to the page cache: read ahead. It greatly influences on the 
performance and a direct I/O application has to reimplement this logic, 
which generally isn't straightforward task.

Vlad
