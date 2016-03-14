From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch v2] scsi_dh_alua: uninitialized variable in alua_check_vpd()
Date: Mon, 14 Mar 2016 16:02:04 -0400
Message-ID: <yq1io0oj0ar.fsf@sermon.lab.mkp.net>
References: <20160311111903.GA12332@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160311111903.GA12332@mwanda> (Dan Carpenter's message of "Fri,
	11 Mar 2016 14:19:03 +0300")
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Johannes Thumshirn <jthumshirn@suse.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> The pg_updated variable is support to be set to false at the start
Dan> but it is uninitialized.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
