From: "Tim Wesemann" <timuel@voicenet.com>
Subject: Re: Adaptec 2200S with aacraid won't do 64-bit
Date: Tue, 22 Feb 2005 16:50:00 -0500
Message-ID: <049d01c51928$7a83a040$de0167cf@voicenet.com>
References: <60807403EABEB443939A5A7AA8A7458BCDC69E@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Received: from mail08.voicenet.com ([207.103.0.34]:58253 "HELO
	mail08.voicenet.com") by vger.kernel.org with SMTP id S261258AbVBVVuJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 16:50:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, linux-scsi@vger.kernel.org

Thanks for your response, Mark.

> Define 64-bit, and how do you making the declaration
> that it is not supported.

I was apparently incorrectly basing it on the register's address space from 
the lspci output. Can you perhaps help me tell a better way to tell if my 
2200S card is using "64-bit mode" (as in whatever the hell marketing people 
mean by 64-bit).

My problem is in a nutshell -- performance. I can't get anything above 
40MB/s writes with this card with 5 15k-spin U320 disks in a raid5. I can 
get better throughput with with a software raid5 running off of my on-board 
AIC-7902 also running at 66MHz  (but presumably in 64 bit mode), but I need 
to use this card...

> The driver does not turn on DAE until there is
> more than 4G of memory in the system to use
> the more optimal 32 bit SG elements.

Does this mean that PCI won't use "64-bit mode" (as in whatever the hell 
marketing people mean by 64-bit) unless I have 4GB of system memory?

Please forgive my apparent ineptitude in these matters, and again thanks for 
your help...

--
Tim Wesemann
Voicenet Systems Administration 

