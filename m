From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v15 4/5] scsi: mpt3sas: Replace PCI pool old API
Date: Mon, 04 Dec 2017 22:20:17 -0500
Message-ID: <yq1y3mh509a.fsf@oracle.com>
References: <20171120193247.8187-1-romain.perier@gmail.com>
        <20171120193247.8187-5-romain.perier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20171120193247.8187-5-romain.perier@gmail.com> (Romain Perier's
        message of "Mon, 20 Nov 2017 20:32:46 +0100")
Sender: linux-pci-owner@vger.kernel.org
To: Romain Perier <romain.perier@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Aviad Krawczyk <aviad.krawczyk@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org, dmaengine@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org


Romain,

> The PCI pool API is deprecated. This commit replaces the PCI pool old
> API by the appropriate function with the DMA pool API.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
