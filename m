From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] Discard update for 3.19
Date: Fri, 07 Nov 2014 10:46:37 -0500
Message-ID: <yq1fvdv9foi.fsf@sermon.lab.mkp.net>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
	<F6E129D0B46B7F4B89EF4089CE55578C045C9146@LAX-EX-MB4.datadirect.datadirectnet.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17595 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaKGPqt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2014 10:46:49 -0500
In-Reply-To: <F6E129D0B46B7F4B89EF4089CE55578C045C9146@LAX-EX-MB4.datadirect.datadirectnet.com>
	(Bernd Schubert's message of "Fri, 7 Nov 2014 12:11:07 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bschubert@ddn.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>

>>>>> "Bernd" == Bernd Schubert <bschubert@ddn.com> writes:

Bernd,

Bernd> I have seen data corruption on an Intel SSD 510 after sending
Bernd> WRITE SAME UNMAP. As far as I remember, these disks ignore writes
Bernd> after sending that command. Unmap worked fine, though. So
Bernd> possibly there is another blacklisting required.

Well, the 510 is a SATA drive and doesn't implement either command so
that would be an LSI SATL problem. I recall that we had some problems
with the LSI firmware blacklisting DRAT/RZAT on that particular drive so
I did the same in my libata patch.

I don't have any bugs open with WRITE SAME or UNMAP on recent LSI
firmware, though. We use it extensively here.

-- 
Martin K. Petersen	Oracle Linux Engineering
