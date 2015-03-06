From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: use dedicated storage for scsi_debug LUNs
Date: Fri, 06 Mar 2015 07:26:26 -0500
Message-ID: <yq1wq2ucnwt.fsf@sermon.lab.mkp.net>
References: <20150305153338.GA16293@aepfle.de> <54F8C923.5010202@interlog.com>
	<20150306091128.GA30096@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31725 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbbCFM0j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 07:26:39 -0500
In-Reply-To: <20150306091128.GA30096@aepfle.de> (Olaf Hering's message of
	"Fri, 6 Mar 2015 10:11:28 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

>>>>> "Olaf" == Olaf Hering <olaf@aepfle.de> writes:

Olaf> On Thu, Mar 05, Douglas Gilbert wrote:
>> So it is possible. The stock answer has typically been that you
>> should probably be using the target subsystem for that.  Thoughts?

Olaf> Is the target subsystem capable of stacking? What I need for
Olaf> xen-scsiback is a bunch of true SCSI devices. Due to lack of
Olaf> hardware, scsi_debug looks like the obvious choice.

I agree with Doug. The target code is much more comprehensive than
scsi_debug. You can set up file/disk/ram-backed SCSI LUNs on your
machine without the need for any hardware .

-- 
Martin K. Petersen	Oracle Linux Engineering
