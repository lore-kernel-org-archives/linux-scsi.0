From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH-v2 02/15] target: Add protected fabric + unprotected device support
Date: Tue, 07 Apr 2015 19:27:21 -0400
Message-ID: <yq1sicbh63q.fsf@sermon.lab.mkp.net>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
	<1427686104-14231-3-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427686104-14231-3-git-send-email-nab@daterainc.com> (Nicholas
	A. Bellinger's message of "Mon, 30 Mar 2015 03:28:11 +0000")
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Doug Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:

nab> This specifically is to allow LIO to perform WRITE_STRIP +
nab> READ_INSERT operations when functioning with non T10-PI enabled
nab> devices, seperate from any available hw offloads the fabric
nab> supports.

How do you handle RDPROTECT/WRPROTECT values of 3 if the PI is not
persistent?

-- 
Martin K. Petersen	Oracle Linux Engineering
