From: Brian King <brking@us.ibm.com>
Subject: Re: Spinup of SCSI Disks: allow_restart won't work on 2.6.18
Date: Tue, 21 Nov 2006 08:41:27 -0600
Message-ID: <45631017.4080601@us.ibm.com>
References: <455DF39A.6090209@fbihome.de> <455E2D44.5030903@gmx.de>	<455E4703.3080005@s5r6.in-berlin.de> <456188FD.3020108@fbihome.de>	<45619611.5020502@s5r6.in-berlin.de> <45622CF5.507@fbihome.de>	<45624009.3040208@s5r6.in-berlin.de> <45624E30.5080605@torque.net>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:18642 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S934364AbWKUOlg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 09:41:36 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kALEfVoi003874
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 09:41:31 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kALEfV5Z246550
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 09:41:31 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kALEfUxn013840
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 09:41:31 -0500
In-Reply-To: <45624E30.5080605@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Joern Quillman <quillman@fbihome.de>, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Stefan Richter wrote:
>> I think the solution is easy: Replace if (sdp->type != TYPE_DISK) by
>>
>> 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_RBC)
> 
> ... but why have the condition at all? What other peripheral
> device type should the _sd_ driver be handling??

Currently, sd attaches TYPE_DISK, TYPE_RBC, and TYPE_MOD devices. I
don't have a problem with removing the check and letting userspace
do what they want to do.

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
