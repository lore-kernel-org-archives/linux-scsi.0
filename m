From: Adrian Bunk <bunk@stusta.de>
Subject: 2.6.11-mm3: megaraid_sas.c: stack usage
Date: Tue, 15 Mar 2005 16:06:42 +0100
Message-ID: <20050315150641.GO3189@stusta.de>
References: <20050312034222.12a264c4.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:272 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261315AbVCOPGo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2005 10:06:44 -0500
Content-Disposition: inline
In-Reply-To: <20050312034222.12a264c4.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Mar 12, 2005 at 03:42:22AM -0800, Andrew Morton wrote:
>...
> All 606 patches:
>...
> megaraid_sas-announcing-new-module-for.patch
>   megaraid_sas: Announcing new module for LSI Logic's SAS based MegaRAID controllers
>...

Enormous stack usage:
- megasas_init_mfi (due to ctrl_info)

Big stack usage:
- megasas_mgmt_ioctl (due to uioc and dv)
- megasas_mgmt_fw_ioctl (due to uioc)

Please fix this.
 
cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

