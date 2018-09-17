From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Contribute to randomness when running rotational device
Date: Mon, 17 Sep 2018 02:58:16 -0400
Message-ID: <yq1zhwgr4on.fsf@oracle.com>
References: <20180906203719.209399-1-xueweiz@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180906203719.209399-1-xueweiz@google.com> (Xuewei Zhang's
        message of "Thu, 6 Sep 2018 13:37:19 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Xuewei Zhang <xueweiz@google.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aditya Kali <adityakali@google.com>, tytso@mit.edu, Guenter Roeck <groeck@chromium.org>, maze@google.com
List-Id: linux-scsi@vger.kernel.org


Xuewei,

> Currently a scsi device won't contribute to kernel randomness when it
> uses blk-mq. Since we commonly use scsi on rotational device with
> blk-mq, it make sense to keep contributing to kernel randomness in these
> cases. This is especially important for virtual machines.

Applied to 4.19/scsi-fixes, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
