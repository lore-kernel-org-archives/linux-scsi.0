From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v5 2/2] arcmsr: simplify of updating doneq_index and postq_index
Date: Mon, 15 Sep 2014 15:29:07 +0200
Message-ID: <5416E9A3.20408@redhat.com>
References: <1410779133.4774.27.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410779133.4774.27.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>, hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/15/2014 01:05 PM, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
>
> This patch is to modify previous patch 16/17 and it is relative to
> http://git.infradead.org/users/hch/scsi-queue.git/tree/arcmsr-for-3.18:/drivers/scsi/arcmsr
>
> change since v4:
> 1. add spin_lock in arcmsr_done4abort_postqueue for protect doneq_index.
> 2. fix spinlock area in arcmsr_hbaD_polling_ccbdone.

You might have kept the previous change log here too,
it's probably better when merged with the 16/17.

I have no more concerns, so

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
