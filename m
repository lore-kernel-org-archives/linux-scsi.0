From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 net-next] qed*: Utilize FW 8.33.11.0
Date: Wed, 28 Mar 2018 11:32:53 -0600
Message-ID: <20180328173253.GE4546@ziepe.ca>
References: <1522226536-9812-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1522226536-9812-1-git-send-email-Michal.Kalderon@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: Michal Kalderon <Michal.Kalderon@cavium.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Tomer Tayar <Tomer.Tayar@cavium.com>, Manish Rangankar <Manish.Rangankar@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 28, 2018 at 11:42:16AM +0300, Michal Kalderon wrote:
> This FW contains several fixes and features
> 
> RDMA Features
> - SRQ support
> - XRC support
> - Memory window support
> - RDMA low latency queue support
> - RDMA bonding support
> 
> RDMA bug fixes
> - RDMA remote invalidate during retransmit fix
> - iWARP MPA connect interop issue with RTR fix
> - iWARP Legacy DPM support
> - Fix MPA reject flow
> - iWARP error handling
> - RQ WQE validation checks
> 
> MISC
> - Fix some HSI types endianity
> - New Restriction: vlan insertion in core_tx_bd_data can't be set
>   for LB packets
> 
> ETH
> - HW QoS offload support
> - Fix vlan, dcb and sriov flow of VF sending a packet with
>   inband VLAN tag instead of default VLAN
> - Allow GRE version 1 offloads in RX flow
> - Allow VXLAN steering
> 
> iSCSI / FcoE
> - Fix bd availability checking flow
> - Support 256th sge proerly in iscsi/fcoe retransmit
> - Performance improvement
> - Fix handle iSCSI command arrival with AHS and with immediate
> - Fix ipv6 traffic class configuration
> 
> DEBUG
> - Update debug utilities
> 
> Signed-off-by: Michal Kalderon <Michal.Kalderon@cavium.com>
> Signed-off-by: Tomer Tayar <Tomer.Tayar@cavium.com>
> Signed-off-by: Manish Rangankar <Manish.Rangankar@cavium.com>
> Signed-off-by: Ariel Elior <Ariel.Elior@cavium.com>
> ---
> Changes from v1
> 	Remove version bump and qedr module version addition
> ---
>  drivers/infiniband/hw/qedr/qedr_hsi_rdma.h         |    4 +-
>  drivers/infiniband/hw/qedr/verbs.c                 |    4 +-
>  drivers/net/ethernet/qlogic/qed/qed_debug.c        |  415 +++--
>  drivers/net/ethernet/qlogic/qed/qed_dev.c          |    4 +-
>  drivers/net/ethernet/qlogic/qed/qed_hsi.h          | 1892 ++++++++++----------
>  .../net/ethernet/qlogic/qed/qed_init_fw_funcs.c    |  103 +-
>  drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |    7 -
>  drivers/net/ethernet/qlogic/qed/qed_l2.c           |    2 +-
>  drivers/net/ethernet/qlogic/qed/qed_ll2.c          |   13 -
>  include/linux/qed/common_hsi.h                     |    2 +-
>  include/linux/qed/eth_common.h                     |    2 +-
>  include/linux/qed/iscsi_common.h                   |    4 +-
>  include/linux/qed/rdma_common.h                    |    2 +
>  include/linux/qed/roce_common.h                    |    3 +
>  14 files changed, 1310 insertions(+), 1147 deletions(-)

For drivers/infiniband:

Acked-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
