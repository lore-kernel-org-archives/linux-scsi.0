From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v16 3/4] hinic: Replace PCI pool old API
Date: Mon, 18 Dec 2017 15:07:01 -0500 (EST)
Message-ID: <20171218.150701.1900289012938357916.davem@davemloft.net>
References: <20171215193123.13395-1-romain.perier@gmail.com>
        <20171215193123.13395-4-romain.perier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171215193123.13395-4-romain.perier@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: romain.perier@gmail.com
Cc: axboe@kernel.dk, akpm@linux-foundation.org, dan.j.williams@intel.com, vinod.koul@intel.com, jeffrey.t.kirsher@intel.com, aviad.krawczyk@huawei.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, bhelgaas@google.com, linux-pci@vger.kernel.org, dmaengine@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, romain.perier@collabora.com
List-Id: linux-scsi@vger.kernel.org

From: Romain Perier <romain.perier@gmail.com>
Date: Fri, 15 Dec 2017 20:31:22 +0100

> From: Romain Perier <romain.perier@collabora.com>
> 
> The PCI pool API is deprecated. This commit replaces the PCI pool old
> API by the appropriate function with the DMA pool API.
> 
> Signed-off-by: Romain Perier <romain.perier@collabora.com>

Acked-by: David S. Miller <davem@davemloft.net>
