From: "IpsLinux" <ipslinux@Adaptec.com>
Subject: RE: IBM Serveraid 4h on PSeries
Date: Tue, 7 Nov 2006 08:38:55 -0500
Message-ID: <BFE32E23E0220B4796F885CF3A46ED0207568B@rtpe2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:16618 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1753774AbWKGNjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2006 08:39:08 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ulrichenslin@christian.net, brking@us.ibm.com, linux-scsi@vger.kernel.org, IpsLinux <ipslinux@adaptec.com>


IBM has never supported ServeRAID ( ips ) on any Pseries machine that I
am aware of.  

I know it has never been tested. 



-----Original Message-----
From: Ulrich Enslin [mailto:ulrichenslin@christian.net] 
Sent: Tuesday, November 07, 2006 4:39 AM
To: brking@us.ibm.com; linux-scsi@vger.kernel.org; IpsLinux
Subject: Re: IBM Serveraid 4h on PSeries

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
OpenSuse and IBM's website only has x86 driver for the Serveraid 4H
card.

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
>> I hope you can help me, or give me clarity or pointers with my
problem.
>>
>> I have a IBM Pseries with a IBM Serveraid 4h card.  I have OpenSuse 
>> 10.1 installed, but it does not see the card.  In the PCI dump the 
>> card is listed, but the IPS driver is missing.
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
