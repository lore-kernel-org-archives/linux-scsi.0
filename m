From: Ulrich Enslin <ulrichenslin@christian.net>
Subject: Re: IBM Serveraid 4h on PSeries
Date: Tue, 07 Nov 2006 11:38:37 +0200
Message-ID: <4550541D.7040905@christian.net>
References: <454EF015.7040206@christian.net> <454FBE3E.2020400@us.ibm.com>
Reply-To: ulrichenslin@christian.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [196.44.37.50] ([196.44.37.50]:28637 "EHLO mailza.softmar.co.za")
	by vger.kernel.org with ESMTP id S1754154AbWKGJhu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2006 04:37:50 -0500
In-Reply-To: <454FBE3E.2020400@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com, linux-scsi@vger.kernel.org, ipslinux@adaptec.com

Hi Brian, linux-scsi team, ipslinux team

Thank you for below reply Brian.  I will not bother you again, but here 
is better details of my problem, since I managed to get hold of the 
documentation that belongs to this server:

I have a IBM Pseries 620 with a Type 4-X, PCI 4-Channel Ultra3 SCSI RAID 
Adapter (FC 2498) (IBM code 4-x). I have OpenSuse 10.1 installed, but 
the raid card is not detected, and show in the PCI diagnostics as a 
Serveraid 4H card. The PCI diagnostics also showed a <access denied> in 
the extension tag.

Can any one tell me what driver I should be loading, or what the true 
identity of the card is under Linux. I found some posts that showed I 
should be using the 'ips' module driver, but this is not found in 
OpenSuse and IBM's website only has x86 driver for the Serveraid 4H card.

Any help will be appreciated.

Thank you for your time.

All the best
Ulrich
ulrichenslin <at> gmail.com

Brian King wrote:
> Ulrich Enslin wrote:
>   
>> Hi
>>
>> I hope you can help me, or give me clarity or pointers with my problem.
>>
>> I have a IBM Pseries with a IBM Serveraid 4h card.  I have OpenSuse 10.1 
>> installed,
>> but it does not see the card.  In the PCI dump the card is listed, but 
>> the IPS driver
>> is missing.
>>
>> I have seen from other posts that the IPS driver only comes with x86 
>> linux distributions.
>>     
>
> The last I knew, this driver didn't work on PPC64.
>
> cc'ing the ips maintainer...
>
>
> Brian
>
>   
