From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 08/10] mpt3sas: Fix possibility of using invalid Enclosure
 Handles for SAS device after host reset
Date: Wed, 11 Oct 2017 18:09:22 +0200
Message-ID: <a6522b4a-0bb4-1351-bc52-5c1e83f44b31@redhat.com>
References: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
 <1507641083-20207-9-git-send-email-Sreekanth.Reddy@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507641083-20207-9-git-send-email-Sreekanth.Reddy@broadcom.com>
Content-Language: en-MW
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi@vger.kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/10/2017 03:11 PM, Sreekanth Reddy wrote:
> Enclosure handles are not updated after host reset.
> As a result, driver device structure is holding previously
>  assigned enclosure handle which is different from the
>  enclosure handle populated in the corresponding device page.
>
> Modified the driver to update devices enclosure handles after
>  host reset to current value, by referring the enclosure handles
>  from corresponding device pages
>
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
