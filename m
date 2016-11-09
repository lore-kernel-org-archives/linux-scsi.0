From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] megaraid_sas: fix macro MEGASAS_IS_LOGICAL to avoid
 regression caused by commit 1e793f6fc0db920400574211c48f9157a37e3945
Date: Wed, 9 Nov 2016 16:51:30 +0100
Message-ID: <80021f6f-54fe-3571-4d17-f29fde363a08@redhat.com>
References: <1478689182-10854-1-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1478689182-10854-1-git-send-email-sumit.saxena@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, shivasharan.srikanteshwara@broadcom.com, axboe@kernel.dk, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 9.11.2016 11:59, Sumit Saxena wrote:
> This patch will fix regression caused by below commit-
> 1e793f6 scsi: megaraid_sas: Fix data integrity failure for JBOD (passthrough) devices
>
> The problem was MEGASAS_IS_LOGICAL macro does not have braces and because of above commit 
> using this macro was exposing lot of non-existing SCSI devices(all SCSI commands to channels-1,2,3 was
> returned as SUCCESS-DID_OK by driver).
>
> Fixes: 1e793f6fc0db920400574211c48f9157a37e3945 
> Reported-by: Jens Axboe <axboe@kernel.dk>
> CC: stable@vger.kernel.org
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> Tested-by: Sumit Saxena <sumit.saxena@broadcom.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
