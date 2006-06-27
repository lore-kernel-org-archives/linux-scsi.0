From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/1] scsi: Add allow_restart sysfs class attribute
Date: Tue, 27 Jun 2006 14:54:43 -0500
Message-ID: <44A18D03.4080705@us.ibm.com>
References: <200606271610.k5RGAXcT005333@d03av04.boulder.ibm.com> <44A18AF7.7000504@s5r6.in-berlin.de>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:19630 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932552AbWF0Tys (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jun 2006 15:54:48 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k5RJslna018580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2006 15:54:47 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k5RJslYH271506
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2006 15:54:47 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k5RJsknq030518
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2006 15:54:47 -0400
In-Reply-To: <44A18AF7.7000504@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, parasietje@gmail.com

Stefan Richter wrote:
> Brian King wrote:
>> This is a resend of a patch I generated in response to an email sent
>> by Ruben Faelens <parasietje@gmail.com>. His original email to
>> linux-scsi requested a method in which he could spin down a scsi disk
>> when not in use and have the kernel automatically spin it back up when
>> an I/O was generated to the disk. The infrastructure to automatically
>> spin a disk up has been in the scsi error handler for some time now,
> 
> I am positively surprised that this code is actually already there --- I 
> didn't notice...
> 
>> but it is not enabled by default. This patch adds an sd sysfs attribute
>> which allows userspace to enable this behavior.
> 
> What is the reason that the code is not enabled by default? Are there 
> dependencies on command set or transport, or firmwares which won't react 
> properly?

There was concern when the patch went in that if it was enabled by default
it would break a bunch of USB devices.

http://marc.theaimsgroup.com/?l=linux-scsi&m=107702811830956&w=2


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
