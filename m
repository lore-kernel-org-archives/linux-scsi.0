From: Brian King <brking@us.ibm.com>
Subject: Re: aic94xx linux driver
Date: Mon, 09 Jan 2006 06:12:18 -0600
Message-ID: <43C25322.9020403@us.ibm.com>
References: <001501c6114f$7a6c3c00$520c220a@vugd.gov.lv> <C8B2ECEF-34CF-4764-A82C-C3144512F449@mac.com> <43BF251F.3060007@torque.net>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43907 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932285AbWAIMMX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2006 07:12:23 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k09CCJ51023882
	for <linux-scsi@vger.kernel.org>; Mon, 9 Jan 2006 07:12:19 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k09CCK5P107868
	for <linux-scsi@vger.kernel.org>; Mon, 9 Jan 2006 07:12:20 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k09CCJWB012550
	for <linux-scsi@vger.kernel.org>; Mon, 9 Jan 2006 07:12:19 -0500
In-Reply-To: <43BF251F.3060007@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Mark Rustad <mrustad@mac.com>, Deniss <denis@msh.lv>, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Mark Rustad wrote:
>> Deniss,
>>
>> On Jan 4, 2006, at 10:54 AM, Deniss wrote:
>>
>>> Hello !
>>>
>>> I have Supermicro 6014H-32 server with adaptec 9410w SAS/SATA 
>>> controller on board.
>>> I have linux kernel compiled with aic94xx driver from http://
>>> linux.adaptec.com/sas/
>>> I am notice that SAS disks work well with this driver, but SATA  disks
>>> are not mapped to /dev by driver.
>>> I tried to contact Luben Tuikov without success.
>>> Looks like aic94xx driver is not complete or have no SATA support
>>
>> I have the same issue. By looking in /sys, you can see that the  driver
>> does see SATA disks, but there is no software connection  between libata
>> in the kernel and the SATA-tunneling protocol  capability of the Adaptec
>> SAS driver yet. I'm sure that there will be  an increasing chorus of
>> folks looking for this missing piece.
> 
> If no-one else is looking at solving this problem
> (libata to aic94xx STP connection) then I may have
> time to look at it.
> 
> I would need (remote) access to a machine with that
> hardware.

Hi Doug,

I'm not working on this specific problem, but I am working on some patches
to libata to make it possible for SAS adapters to attach SATA devices
through libata. I'm in the process of refreshing them since the last
time I posted them.

Brian


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
