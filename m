From: Douglas Gilbert <dougg@torque.net>
Subject: Re: aic94xx linux driver
Date: Sat, 07 Jan 2006 12:19:11 +1000
Message-ID: <43BF251F.3060007@torque.net>
References: <001501c6114f$7a6c3c00$520c220a@vugd.gov.lv> <C8B2ECEF-34CF-4764-A82C-C3144512F449@mac.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:20460 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1752511AbWAGCSq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2006 21:18:46 -0500
In-Reply-To: <C8B2ECEF-34CF-4764-A82C-C3144512F449@mac.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Rustad <mrustad@mac.com>
Cc: Deniss <denis@msh.lv>, linux-scsi@vger.kernel.org

Mark Rustad wrote:
> Deniss,
> 
> On Jan 4, 2006, at 10:54 AM, Deniss wrote:
> 
>> Hello !
>>
>> I have Supermicro 6014H-32 server with adaptec 9410w SAS/SATA 
>> controller on board.
>> I have linux kernel compiled with aic94xx driver from http://
>> linux.adaptec.com/sas/
>> I am notice that SAS disks work well with this driver, but SATA  disks
>> are not mapped to /dev by driver.
>> I tried to contact Luben Tuikov without success.
>> Looks like aic94xx driver is not complete or have no SATA support
> 
> 
> I have the same issue. By looking in /sys, you can see that the  driver
> does see SATA disks, but there is no software connection  between libata
> in the kernel and the SATA-tunneling protocol  capability of the Adaptec
> SAS driver yet. I'm sure that there will be  an increasing chorus of
> folks looking for this missing piece.

If no-one else is looking at solving this problem
(libata to aic94xx STP connection) then I may have
time to look at it.

I would need (remote) access to a machine with that
hardware.

Doug Gilbert
