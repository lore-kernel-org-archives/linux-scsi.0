From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: ibmvfc: constify dev_pm_ops structures.
Date: Thu, 29 Jun 2017 15:39:45 -0700
Message-ID: <07f4c01f-4937-9790-703a-b2db8934ddd8@linux.vnet.ibm.com>
References: <c0ec5db7e2c3313cb7b417e76330520fd2b6136c.1498722828.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c0ec5db7e2c3313cb7b417e76330520fd2b6136c.1498722828.git.arvind.yadav.cs@gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>, tyreld@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/29/2017 12:54 AM, Arvind Yadav wrote:
> dev_pm_ops are not supposed to change at runtime. All functions
> working with dev_pm_ops provided by <linux/device.h> work with const
> dev_pm_ops. So mark the non-const structs as const.
> 
> File size before:
>    text	   data	    bss	    dec	    hex	filename
>   41937	   1296	     20	  43253	   a8f5	drivers/scsi/ibmvscsi/ibmvfc.o
> 
> File size After adding 'const':
>    text	   data	    bss	    dec	    hex	filename
>   42129	   1104	     20	  43253	   a8f5	drivers/scsi/ibmvscsi/ibmvfc.o
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
