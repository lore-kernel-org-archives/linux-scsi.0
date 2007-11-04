From: Anthony Ewell <amewell@verizon.net>
Subject: Re: slow after upgrade to CentOS 5 (RHEL5)
Date: Sun, 04 Nov 2007 15:16:16 -0800
Message-ID: <472E52C0.4080604@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vms040pub.verizon.net ([206.46.252.40]:35051 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbXKDWQh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Nov 2007 17:16:37 -0500
Received: from rn1.rent-a-nerd.local ([72.75.170.182])
 by vms040.mailsrvcs.net (Sun Java System Messaging Server 6.2-6.01 (built Apr
 3 2006)) with ESMTPA id <0JR0000K45V5OR57@vms040.mailsrvcs.net> for
 linux-scsi@vger.kernel.org; Sun, 04 Nov 2007 16:16:18 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bo.yang@lsi.com, James Bottomley <James.Bottomley@SteelEye.com>, "Patro, Sumant" <Sumant.Patro@lsi.com>, Mark Harvey <mark_harvey@symantec.com>

James Bottomley wrote:
> Please don't drop the cc lists.  There are others who probably have more
> informed opinions than I do who won't get to comment if they don't see
> it.
>
> On Sun, 2007-10-28 at 17:36 -0700, Anthony Ewell wrote:
>> James Bottomley wrote:
>>> On Sat, 2007-10-27 at 13:21 -0700, Anthony Ewell wrote:
>>>> James Bottomley wrote:
>>>>> On Wed, 2007-10-24 at 18:04 -0700, Anthony Ewell wrote:
>>>>>> Hi All,
>>>>>>
>>>>>>     If you all would not mind a post from the general
>>>>>> public Linux user, after doing a complete disk wipe
>>>>>> of CentOS 4 and installing CentOS5, my system is preceived
>>>>>> to be 3 times slower.


Did some test from my install CD/DVD's in "rescue mode" on
Computer C.  I used the same backup script (dump) that
I use in normal boot mode.  I stopped the backup
after dump gave the first estimate of time:

    "dump" CentOS5 install DVD in rescue mode:
         transfer rate 4422 KB/s, estimated  finish 4:10

    "dump" CentOS4.4 (2.6.9-42.EL) install CD in rescue mode:
         transfer rate 8468 KB/s, estimated  finish 2:09

I also got a "dmesg" from computer B, as requested by Sumant.
Computer B: VXA-3, CentOS 4.5 , SATA-150-4

-T

Hi All,

I also tested using the System Rescue CD from
         http://www.sysresccd.org.

I used the same backup script (dump) that I use in normal
boot mode. I stopped the backup after dump gave the first
estimate of time:

    "dump" System Rescue CD (Kernel 2.6.22.9):
         transfer rate 4370 KB/s, estimated finish 4:15

So, I would say, the problem is not confined to CentOS 5,
but goes all the way up to the 2.6.22.9 kernel.  I hope
this is a good clue.

-T
