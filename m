From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] scsi: Fix sense information setting in fixed sized format
Date: Sun, 12 Jul 2015 09:36:26 +0300
Message-ID: <55A20AEA.6060808@dev.mellanox.co.il>
References: <1436367603-16456-1-git-send-email-sagig@mellanox.com>
 <20150711112742.GA7883@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36732 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbbGLGga (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jul 2015 02:36:30 -0400
Received: by widjy10 with SMTP id jy10so43927890wid.1
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2015 23:36:29 -0700 (PDT)
In-Reply-To: <20150711112742.GA7883@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>


> This looks correct to me,
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> But: this will truncate > 32bit sector numbers.  Maybe we need to
> enable descriptor format sense data for large enough LUs.

That should be easy enough now that the sense data is constructed using
scsi helpers.

Let me prepare a patch for that.
