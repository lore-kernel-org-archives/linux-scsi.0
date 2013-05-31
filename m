From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: qc_fill_rtf() method should not store alternate
 status register
Date: Fri, 31 May 2013 07:46:51 -0500
Message-ID: <51A89BBB.1030705@linux.vnet.ibm.com>
References: <201305212324.22822.sergei.shtylyov@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <201305212324.22822.sergei.shtylyov@cogentembedded.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: brking@us.ibm.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/21/2013 02:24 PM, Sergei Shtylyov wrote:
> The 'ctl' field of  the 'struct ata_taskfile' is not really dual purpose, i.e.
> it is not intended  for storing the alternate status register (which is mapped
> at the same address in the legacy IDE controllers) in the qc_fill_rtf() method.
> No other 'libata' driver except 'drivers/scsi/ipr.c' stores the alternate status
> register's value in the 'ctl' field of 'qc->result_tf', hence this driver should
> not do this as well...
> 
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


