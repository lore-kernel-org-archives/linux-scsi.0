From: Krishna Murthy <krmurthy@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 19 Nov 2003 18:10:30 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311191810.30135.krmurthy@cisco.com>
References: <20031027153932.A16679@infradead.org> <03111117263601.01918@naveenb-lnx.cisco.com> <20031111173622.A12435@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:4645 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S264024AbTKSMlu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Nov 2003 07:41:50 -0500
In-Reply-To: <20031111173622.A12435@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, davmyers@cisco.com

Hi ,
	The following was one of your comments on the iSCSI driver:

"having multiple  kmap() in the same process at the same time can kmap(),
you redesign iscsi_xmit_task/iscsi_xmit_data/iscsi_recv_data not to do that.
for the tx path use ->sendpage to avoid a data copy and kmapping altogether"


In the first line did you intend to say having multiple kmap() can deadlock?
Regarding usage of sendpage and avoiding kmapping altogether, 
we need to access the data, to calculate data digest.  If we do  not use kmap
how else do we achieve it?

Please let us know.

Thanx
N.C.Krishna Murthy



> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
