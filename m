From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/5] bfa: mark symbols static where possible
Date: Wed, 03 Aug 2016 09:46:01 +0200
Message-ID: <4472099.0XASieJnNU@wuerfel>
References: <201608031208.Y8UqZJYW%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:65356 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbcHCHxI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2016 03:53:08 -0400
In-Reply-To: <201608031208.Y8UqZJYW%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Baoyou Xie <baoyou.xie@linaro.org>

On Wednesday, August 3, 2016 12:45:50 PM CEST kbuild test robot wrote:
> All errors (new ones prefixed by >>):
> 
>    drivers/scsi/bfa/bfad.c: In function 'bfad_drv_uninit':
> >> drivers/scsi/bfa/bfad.c:888:2: error: implicit declaration of function 'bfa_isr_disable' [-Werror=implicit-function-declaration]
>      bfa_isr_disable(&bfad->bfa);
>      ^
>    cc1: some warnings being treated as errors
> 

Ah right: This is called in a function that gets removed in patch 5,
after which it is actually local. I made a mistake here when I went
through a repeated search for local functions.

I'll wait for other comments first before I send a fixed version.

	Arnd


