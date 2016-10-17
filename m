From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 7/7] megaraid_sas: Do not set MPI2_TYPE_CUDA for JBOD FP
 path for FW which does not support JBOD sequence map
Date: Mon, 17 Oct 2016 15:23:07 +0200
Message-ID: <811b34f0-2876-7107-4559-d5144bff405f@redhat.com>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-8-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1476699850-25083-8-git-send-email-sumit.saxena@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 17.10.2016 12:24, Sumit Saxena wrote:
> Do not set MPI2_TYPE_CUDA for JBOD fastpath IOs for firmware which does
> not support JBOD sequence map.
>
> CC: stable@vger.kernel.org
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
