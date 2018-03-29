From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next] qed*: Utilize FW 8.33.11.0
Date: Thu, 29 Mar 2018 14:18:40 -0400 (EDT)
Message-ID: <20180329.141840.1799263974241169651.davem@davemloft.net>
References: <1522226536-9812-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1522226536-9812-1-git-send-email-Michal.Kalderon@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: Michal.Kalderon@cavium.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Tomer.Tayar@cavium.com, Manish.Rangankar@cavium.com, Ariel.Elior@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Michal Kalderon <Michal.Kalderon@cavium.com>
Date: Wed, 28 Mar 2018 11:42:16 +0300

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

Applied.
