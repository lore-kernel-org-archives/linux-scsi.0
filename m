From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] cxgb4: use new fw interface to get the VIN
 and smt index
Date: Thu, 22 Nov 2018 10:53:49 -0800 (PST)
Message-ID: <20181122.105349.1035544140286401266.davem@davemloft.net>
References: <1542787824-4731-1-git-send-email-ganeshgr@chelsio.com>
        <20181122024624.GA28494@ziepe.ca>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181122024624.GA28494@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: jgg@ziepe.ca
Cc: ganeshgr@chelsio.com, netdev@vger.kernel.org, nirranjan@chelsio.com, indranil@chelsio.com, dt@chelsio.com, linux-rdma@vger.kernel.org, swise@opengridcomputing.com, linux-crypto@vger.kernel.org, atul.gupta@chelsio.com, linux-scsi@vger.kernel.org, varun@chelsio.com, santosh@chelsio.com
List-Id: linux-scsi@vger.kernel.org

From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Wed, 21 Nov 2018 19:46:24 -0700

> On Wed, Nov 21, 2018 at 01:40:24PM +0530, Ganesh Goudar wrote:
>> From: Santosh Rastapur <santosh@chelsio.com>
>> 
>> If the fw supports returning VIN/VIVLD in FW_VI_CMD save it
>> in port_info structure else retrieve these from viid and save
>> them  in port_info structure. Do the same for smt_idx from
>> FW_VI_MAC_CMD
>> 
>> Signed-off-by: Santosh Rastapur <santosh@chelsio.com>
>> Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>
>>  drivers/crypto/chelsio/chtls/chtls_cm.c         |  3 +-
>>  drivers/infiniband/hw/cxgb4/cm.c                |  6 +--
>>  drivers/net/ethernet/chelsio/cxgb4/cxgb4.h      | 12 ++++-
>>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 58 ++++++++++++-------------
>>  drivers/net/ethernet/chelsio/cxgb4/l2t.c        | 13 +++---
>>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c      | 46 ++++++++++++++++++--
>>  drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h   | 20 +++++++++
>>  drivers/scsi/cxgbi/cxgb4i/cxgb4i.c              |  3 +-
>>  drivers/target/iscsi/cxgbit/cxgbit_cm.c         |  8 ++--
>>  9 files changed, 114 insertions(+), 55 deletions(-)
> 
> Applied to for-next, but please try to write better commit messages in
> future, explain what benifit your change is bringing.

The subject line indicates this is targetting my net-next tree, therefore
why did you apply it to your's?
