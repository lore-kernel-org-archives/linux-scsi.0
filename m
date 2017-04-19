From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ibmvfc: don't check for failure from mempool_alloc()
Date: Tue, 18 Apr 2017 21:51:28 -0400
Message-ID: <yq1h91ltba7.fsf@oracle.com>
References: <878tn9xb2m.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878tn9xb2m.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Mon, 10 Apr 2017 12:15:13 +1000")
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NeilBrown <neilb@suse.com> writes:

> mempool_alloc() cannot fail when passed GFP_NOIO or any other gfp
> setting that is permitted to sleep.  So remove this pointless code.

Applied to 4.12/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
