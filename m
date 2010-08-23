From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/6] libata: Signal that our SATL supports WRITE SAME(16) with UNMAP
Date: Mon, 23 Aug 2010 15:11:32 -0400
Message-ID: <yq1zkwdrvob.fsf@sermon.lab.mkp.net>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
	<1282232941-9910-2-git-send-email-martin.petersen@oracle.com>
	<4C723215.3080507@kernel.org> <4C72BC60.4090705@interlog.com>
	<4C72BDF0.7080000@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:40603 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab0HWTMx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2010 15:12:53 -0400
In-Reply-To: <4C72BDF0.7080000@interlog.com> (Douglas Gilbert's message of
	"Mon, 23 Aug 2010 14:29:04 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Tejun Heo <tj@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

>> And when I do then I see that rbuf[3] should be 4 (not 0x3c) unless
>> the DP bit is set.

I totally missed the DP bit when I read the spec.


Doug> ... and of course rbuf[1] should be 0xb2 . Martin ????  The
Doug> rbuf[5] line is correct :-)

Copy and paste error.

I'll get these fixed up right away...

-- 
Martin K. Petersen	Oracle Linux Engineering
