From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH, RESEND] Avoid that SCSI device removal through sysfs triggers a deadlock
Date: Wed, 25 Jul 2018 21:47:02 -0400
Message-ID: <yq1va9222g9.fsf@oracle.com>
References: <20180725173828.2227-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180725173828.2227-1-bart.vanassche@wdc.com> (Bart Van Assche's
        message of "Wed, 25 Jul 2018 10:38:28 -0700")
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Eric W . Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Bart,

> This patch avoids that self-removal triggers the following deadlock:

Somebody please review this so we can get it merged.

-- 
Martin K. Petersen	Oracle Linux Engineering
