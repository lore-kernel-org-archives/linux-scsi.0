From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: BLKDISCARD and AIO
Date: Wed, 23 Oct 2013 04:42:30 -0400
Message-ID: <yq1r4bcfkeh.fsf@sermon.lab.mkp.net>
References: <201310221413.r9MEDQpK002617@bldi04p.dell-idc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48772 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3JWImg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2013 04:42:36 -0400
In-Reply-To: <201310221413.r9MEDQpK002617@bldi04p.dell-idc.com> (Menny
	Hamburger's message of "Tue, 22 Oct 2013 17:13:26 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Menny Hamburger <Menny_Hamburger@Dell.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Menny" == Menny Hamburger <Menny_Hamburger@Dell.com> writes:

Menny> I have a question regarding the use of BLKDISCARD ioctl in
Menny> userland code: Is there currently a way to hook up with an
Menny> asyncronous event that can be polled by userland when the
Menny> operation completes? 

Not at this time, no.

However, you can fork a child process to execute the ioctl and wait for
that to complete.

-- 
Martin K. Petersen	Oracle Linux Engineering
