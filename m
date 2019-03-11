From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi/dpt_i2o.c: Use dma_zalloc_coherent
Date: Mon, 11 Mar 2019 09:13:49 -0700
Message-ID: <1552320829.2889.11.camel@linux.vnet.ibm.com>
References: <5c8683f7.1c69fb81.e37f9.75a0@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5c8683f7.1c69fb81.e37f9.75a0@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sabyasachi Gupta <sabyasachi.linux@gmail.com>, akpm@linux-foundation.org
Cc: aacraid@microsemi.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jrdr.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 2019-03-11 at 21:21 +0530, Sabyasachi Gupta wrote:
> Replaced dma_alloc_coherent + memset with dma_zalloc_coherent

I really don't think so.  This API is going away:

https://lkml.org/lkml/2019/1/8/394

James
