From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next 00/11] qed*: Improve performance on 100G
 link for offload protocols
Date: Sun, 26 May 2019 13:04:32 -0700 (PDT)
Message-ID: <20190526.130432.605011257219662109.davem@davemloft.net>
References: <20190526122230.30039-1-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190526122230.30039-1-michal.kalderon@marvell.com>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@marvell.com
Cc: ariel.elior@marvell.com, dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>
Date: Sun, 26 May 2019 15:22:19 +0300

> This patch series modifies the current implementation of PF selection.
> The refactoring of the llh code enables setting additional filters
> (mac / protocol) per PF, and improves performance for offload protocols
> (RoCE, iWARP, iSCSI, fcoe) on 100G link (was capped at 90G per single
> PF).
> 
> Improved performance on 100G link is achieved by configuring engine
> affinty to each PF.
> The engine affinity is read from the Management FW and hw is configured accordingly.
> A new hw resource called PPFID is exposed and an API is introduced to utilize
> it. This additional resource enables setting the affinity of a PF and providing
> more classification rules per PF.
> qedr,qedi,qedf are also modified as part of the series. Without the
> changes functionality is broken.
> 
> v1 --> v2
> ---------
> - Remove iWARP module parameter. Instead use devlink param infrastructure
>   for setting the iwarp_cmt mode. Additional patch added to the series for
>   adding the devlink support.
> 
> - Fix kbuild test robot warning on qed_llh_filter initialization.
> 
> - Remove comments inside function calls

Series applied, thanks.
