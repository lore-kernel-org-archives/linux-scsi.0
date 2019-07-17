From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2] scsi: fix race on creating sense cache
Date: Tue, 16 Jul 2019 22:43:42 -0400
Message-ID: <yq1blxtz8gx.fsf@oracle.com>
References: <20190712020819.31935-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190712020819.31935-1-ming.lei@redhat.com> (Ming Lei's message
        of "Fri, 12 Jul 2019 10:08:19 +0800")
Sender: stable-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Stable <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, "Ewan D . Milne" <emilne@redhat.com>
List-Id: linux-scsi@vger.kernel.org


Ming,

> When scsi_init_sense_cache(host) is called concurrently from different
> hosts, each code path may see that the cache isn't created, then try
> to create a new one, then the created sense cache may be overrided and
> leaked.
>
> Fixes the issue by moving 'mutex_lock(&scsi_sense_cache_mutex)' before
> scsi_select_sense_cache().

Applied to 5.3/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
