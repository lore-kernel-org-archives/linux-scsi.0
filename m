From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: LSF Papers online?
Date: Fri, 17 Apr 2009 00:44:36 -0400
Message-ID: <yq1eivrx51n.fsf@sermon.lab.mkp.net>
References: <49E335BA.3020103@panasas.com>
	<da824cf30904161436y1a886789mdb05f38a850c5b46@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:24331 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbZDQFT2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 01:19:28 -0400
In-Reply-To: <da824cf30904161436y1a886789mdb05f38a850c5b46@mail.gmail.com>
	(Grant Grundler's message of "Thu, 16 Apr 2009 14:36:17 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Zach Brown <zach.brown@oracle.com>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>>>>> "Grant" == Grant Grundler <grundler@google.com> writes:

Grant>     http://iou.parisc-linux.org/lsf2009/tripreport.txt

Just a correction to your 4KB sector support minutes:

READ CAPACITY(16) does report the actual alignment.  The same is true
for ATA IDENTIFY.  The reporting method is slightly different between
the two protocols but the net result is the same.

-- 
Martin K. Petersen	Oracle Linux Engineering

