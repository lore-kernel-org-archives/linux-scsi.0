From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Fix discard granularity when LBPRZ=1
Date: Mon, 07 Mar 2016 21:21:20 -0500
Message-ID: <yq1h9ghyajj.fsf@sermon.lab.mkp.net>
References: <20160304152409.GA31358@redhat.com>
	<1457219421-836-1-git-send-email-martin.petersen@oracle.com>
	<1457365328.16707.65.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28445 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142AbcCHCV2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 21:21:28 -0500
In-Reply-To: <1457365328.16707.65.camel@localhost.localdomain> (Ewan Milne's
	message of "Mon, 07 Mar 2016 10:42:08 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ewan Milne <emilne@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, snitzer@redhat.com

>>>>> "Ewan" == Ewan Milne <emilne@redhat.com> writes:
>> Commit 397737223c59 ("sd: Make discard granularity match logical
>> block size when LBPRZ=1") accidentally set the granularity to one
>> byte instead of one logical block on devices that provide determistic
>> zeroes after UNMAP.

Ewan> Reviewed-by: Ewan D. Milne <emilne@redhat.com>

I'll need another reviewer for this.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
