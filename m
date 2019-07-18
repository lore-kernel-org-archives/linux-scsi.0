From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ses: Fix out-of-bounds memory access in ses_enclosure_data_process()
Date: Thu, 18 Jul 2019 14:26:33 -0400
Message-ID: <yq1blxrxkpy.fsf@oracle.com>
References: <20190501180535.26718-1-longman@redhat.com>
        <1fd39969-4413-2f11-86b2-729787680efa@redhat.com>
        <1558363938.3742.1.camel@linux.ibm.com>
        <729b0751-01a6-7c0b-ce0d-f19807b59dee@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <729b0751-01a6-7c0b-ce0d-f19807b59dee@redhat.com> (Waiman Long's
        message of "Thu, 18 Jul 2019 14:18:25 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Waiman Long <longman@redhat.com>
Cc: James Bottomley <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Waiman,

> Is someone going to merge this patch in the current cycle?

I was hoping somebody would step up and patch all the bad accesses and
not just page 10.

-- 
Martin K. Petersen	Oracle Linux Engineering
