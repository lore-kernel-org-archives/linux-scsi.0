From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 0/2] Update SCSI target removal path
Date: Tue, 05 Apr 2016 07:18:32 -0400
Message-ID: <yq1d1q4b8xj.fsf@sermon.lab.mkp.net>
References: <cover.1459848136.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1459848136.git.jthumshirn@suse.de> (Johannes Thumshirn's
	message of "Tue, 5 Apr 2016 11:50:43 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> This is a follow up to "scsi: Add intermediate STARGET_REMOVE
Johannes> state to scsi_target_state".

James suggested we should let this incubate before hitting stable.

Dropped v3 from 4.6/scsi-fixes and applied v4 to 4.7/scsi-queue.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
