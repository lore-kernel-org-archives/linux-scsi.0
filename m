From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] give ->proc_info a struct Scsi_Host * parameter
Date: Tue, 13 May 2003 17:00:54 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC09826.20406@torque.net>
References: <20030512160344.A11185@lst.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:61454 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263201AbTEMGpX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2003 02:45:23 -0400
In-Reply-To: <20030512160344.A11185@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> Yeah, I know the method is obsolete but for proper refcounting we
> need to get rid of all those scsi_host_hn_get() abusers.
> 
> scsi_host_hn_get() and scsi_host_put() are not exported anymore
> after this patch.

Christoph,
I'm working on a patch to add a virtual device node in the
sg driver tentatively called /dev/sgbind. It follows on
from a suggestion by Patrick Mansfield recently to allow
device scanning from the user space.

It is work in progress and I will send some patches
and/or RFCs shortly. To do this I need access to
scsi_host_hn_get() and scsi_host_put() so please leave
them exported.

Doug Gilbert


