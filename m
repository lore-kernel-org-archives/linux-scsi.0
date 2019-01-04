From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] target/iscsi: fix error msg typo when create lio_qr_cache failed
Date: Thu, 03 Jan 2019 23:40:26 -0500
Message-ID: <yq1imz58285.fsf@oracle.com>
References: <1545581907-920233-1-git-send-email-nguzcf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545581907-920233-1-git-send-email-nguzcf@gmail.com> (Leo
        Zhang's message of "Mon, 24 Dec 2018 00:18:27 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Leo Zhang <nguzcf@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Matthew Wilcox <willy@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, Colin Ian King <colin.king@canonical.com>, Laura Abbott <labbott@redhat.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Leo,

> -		pr_err("nable to kmem_cache_create() for"
> +		pr_err("Unable to kmem_cache_create() for"
>  				" lio_qr_cache\n");

Applied to 4.21/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
