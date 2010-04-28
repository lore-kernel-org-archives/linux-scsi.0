From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 09/11] qla4xxx: Added support for ISP82XX
Date: Wed, 28 Apr 2010 01:37:21 -0500
Message-ID: <4BD7D7A1.3040507@cs.wisc.edu>
References: <20100428061431.GA11197@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41107 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab0D1Ggx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Apr 2010 02:36:53 -0400
In-Reply-To: <20100428061431.GA11197@sles11sp1b1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

On 04/28/2010 01:14 AM, Vikas Chaudhary wrote:
> Signed-off-by: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
> Signed-off-by: Ravi Anand<ravi.anand@qlogic.com>
> Signed-off-by: Karen Higgins<karen.higgins@qlogic.com>
> ---
>   drivers/scsi/qla4xxx/Kconfig      |    4 +-
>   drivers/scsi/qla4xxx/Makefile     |    2 +-
>   drivers/scsi/qla4xxx/ql4_def.h    |  145 ++-
>   drivers/scsi/qla4xxx/ql4_fw.h     |  144 +++-
>   drivers/scsi/qla4xxx/ql4_glbl.h   |  115 ++-
>   drivers/scsi/qla4xxx/ql4_init.c   |  190 ++-
>   drivers/scsi/qla4xxx/ql4_inline.h |    2 +-
>   drivers/scsi/qla4xxx/ql4_iocb.c   |   73 +-
>   drivers/scsi/qla4xxx/ql4_isr.c    |  400 +++++-
>   drivers/scsi/qla4xxx/ql4_mbx.c    |  185 ++-
>   drivers/scsi/qla4xxx/ql4_nvram.c  |    2 +-
>   drivers/scsi/qla4xxx/ql4_nvram.h  |    6 +-
>   drivers/scsi/qla4xxx/ql4_nx.c     | 2556 +++++++++++++++++++++++++++++++++++++
>   drivers/scsi/qla4xxx/ql4_nx.h     |  703 ++++++++++
>   drivers/scsi/qla4xxx/ql4_os.c     |  693 ++++++++---
>   15 files changed, 4831 insertions(+), 389 deletions(-)
>   create mode 100644 drivers/scsi/qla4xxx/ql4_nx.c


I did not review this patch adding new hw support due to waiting on 
comments about the other patches.


The other patches look ok now. They just have comment about adding a 
KERN_ in the printks but I think that is ignorable. Add a:
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>


This patch:
[PATCH 08/11] qla4xxx: fix ql4_mbx tcp_source_port_num
is already in Linus's tree I think, so it can be dropped by James if he 
likes the patches.
