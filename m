From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] qla2xxx: small cleanup in qla2x00_wait_for_hba_ready()
Date: Mon, 08 Aug 2016 21:29:15 -0400
Message-ID: <yq1wpjqu3v8.fsf@sermon.lab.mkp.net>
References: <20160803184232.GA775@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160803184232.GA775@mwanda> (Dan Carpenter's message of "Wed, 3
	Aug 2016 21:42:32 +0300")
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: qla2xxx-upstream@qlogic.com, Sawan Chandak <sawan.chandak@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> The "if (test_bit(UNLOADING..." line was indented one tab more than
Dan> it should have been.  There was an extra parenthesis around the
Dan> qla2x00_reset_active() function call.  I lined up the conditions a
Dan> bit so that it shows how they group together.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
