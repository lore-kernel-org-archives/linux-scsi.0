From: Alex Aizman <itn780@yahoo.com>
Subject: Re: [ANNOUNCE 0/6] Open-iSCSI High-Performance Initiator for Linux
Date: Tue, 08 Mar 2005 21:51:39 -0800
Message-ID: <422E8EEB.7090209@yahoo.com>
References: <422BFCB2.6080309@yahoo.com> <20050309050434.GT3163@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from smtp108.mail.sc5.yahoo.com ([66.163.170.6]:58554 "HELO
	smtp108.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261440AbVCIFwJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2005 00:52:09 -0500
In-Reply-To: <20050309050434.GT3163@waste.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Matt Mackall wrote:

>How big is the userspace client?
>  
>
Hmm.. x86 executable? source?

Anyway, there's about 12,000 lines of user space code, and growing. In 
the kernel we have approx. 3,300 lines.

>>- 450MB/sec Read on a single connection (2-way 2.4Ghz Opteron, 64KB block 
>>size);
>>    
>>
>
>With what network hardware and drives, please?
>
>  
>
Neterion's 10GbE adapters. RAM disk on the target side.

Alex
