From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] qed*: Utilize FW 8.37.2.0
Date: Tue, 05 Jun 2018 10:48:37 -0400 (EDT)
Message-ID: <20180605.104837.461936459830856823.davem@davemloft.net>
References: <20180605101116.30292-1-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180605101116.30292-1-Michal.Kalderon@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: Michal.Kalderon@cavium.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Ariel.Elior@cavium.com, manish.rangankar@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Michal Kalderon <Michal.Kalderon@cavium.com>
Date: Tue, 5 Jun 2018 13:11:16 +0300

> This FW contains several fixes and features.
> 
> RDMA
> - Several modifications and fixes for Memory Windows
> - drop vlan and tcp timestamp from mss calculation in driver for
>   this FW
> - Fix SQ completion flow when local ack timeout is infinite
> - Modifications in t10dif support
> 
> ETH
> - Fix aRFS for tunneled traffic without inner IP.
> - Fix chip configuration which may fail under heavy traffic conditions.
> - Support receiving any-VNI in VXLAN and GENEVE RX classification.
> 
> iSCSI / FcoE
> - Fix iSCSI recovery flow
> - Drop vlan and tcp timestamp from mss calc for fw 8.37.2.0
> 
> Misc
> - Several registers (split registers) won't read correctly with
>   ethtool -d
> 
> Signed-off-by: Ariel Elior <Ariel.Elior@cavium.com>
> Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
> Signed-off-by: Michal Kalderon <Michal.Kalderon@cavium.com>

Applied, thank you.
