From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 03/10] mpt3sas: Reduce memory footprints in kdump kernel
Date: Wed, 11 Oct 2017 17:33:37 +0200
Message-ID: <c29a8e75-81a4-f0ff-9d47-d59730b873f3@redhat.com>
References: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
 <1507641083-20207-4-git-send-email-Sreekanth.Reddy@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507641083-20207-4-git-send-email-Sreekanth.Reddy@broadcom.com>
Content-Language: en-MW
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi@vger.kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/10/2017 03:11 PM, Sreekanth Reddy wrote:
> To reduce the memory footprints of the driver in kdump kernel,
>  we have made below driver setting when system boots in to kdump kernel,
>
> 1. Used single MSI-x vector.
> 2. Disable RDPQ mode.
> 3. Set sg_table_size to 32 by default.
> 4) Set SCSI IO Queue depth to 200.
>
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>

I think that preferred is (though not much used yet) instead of 'reset_devices'
to use a 'is_kdump_kernel()' function. 

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
