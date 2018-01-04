From: Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v17 0/4] Replace PCI pool by DMA pool API
Date: Thu, 4 Jan 2018 16:59:44 +0100
Message-ID: <CABgxDoLGGYGoEsmUgxk7RWFwc9WD5DBi53sBVsvKjwtM_AehjQ@mail.gmail.com>
References: <20180102175356.7999-1-romain.perier@gmail.com>
 <20180102221724.GE6211@bhelgaas-glaptop.roam.corp.google.com> <20180103213433.GA189303@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180103213433.GA189303@bhelgaas-glaptop.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Aviad Krawczyk <aviad.krawczyk@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org, dmaengine@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, netdev <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

Ok, will do. Thanks !

Romain

2018-01-03 22:34 GMT+01:00 Bjorn Helgaas <helgaas@kernel.org>:
> On Tue, Jan 02, 2018 at 04:17:24PM -0600, Bjorn Helgaas wrote:
>> On Tue, Jan 02, 2018 at 06:53:52PM +0100, Romain Perier wrote:
>> > The current PCI pool API are simple macro functions direct expanded to
>> > the appropriate dma pool functions. The prototypes are almost the same
>> > and semantically, they are very similar. I propose to use the DMA pool
>> > API directly and get rid of the old API.
>> >
>> > This set of patches, replaces the old API by the dma pool API
>> > and remove the defines.
>> > ...
>>
>> > Romain Perier (4):
>> >   block: DAC960: Replace PCI pool old API
>> >   net: e100: Replace PCI pool old API
>> >   hinic: Replace PCI pool old API
>> >   PCI: Remove PCI pool macro functions
>> >
>> >  drivers/block/DAC960.c                            | 38 +++++++++++------------
>> >  drivers/block/DAC960.h                            |  4 +--
>> >  drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c | 10 +++---
>> >  drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h |  2 +-
>> >  drivers/net/ethernet/intel/e100.c                 | 12 +++----
>> >  include/linux/pci.h                               |  9 ------
>> >  6 files changed, 32 insertions(+), 43 deletions(-)
>>
>> Applied to pci/misc for v4.16, thanks!
>
> Oops, my mistake.  I can't remove the macros themselves yet because
> some of the uses were removed by patches that were applied via other
> trees, and those patches are not in my tree.
>
> To avoid ordering dependencies during the merge window, I dropped the
> "PCI: Remove PCI pool macro functions" patch.  Please repost that
> after all the removals have made it into Linus' tree.
>
> Bjorn
