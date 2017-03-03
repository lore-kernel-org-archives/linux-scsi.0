From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v4 09/19] scsi: csiostor: Replace PCI pool old API
Date: Fri, 3 Mar 2017 12:27:56 +0300
Message-ID: <574c28f1-cf16-544b-7b9b-ce4d293193b1@cogentembedded.com>
References: <20170301155521.30281-1-romain.perier@collabora.com>
 <20170301155521.30281-10-romain.perier@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170301155521.30281-10-romain.perier@collabora.com>
Sender: netdev-owner@vger.kernel.org
To: Romain Perier <romain.perier@collabora.com>, Dan Williams <dan.j.williams@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, jeffrey.t.kirsher@intel.com, "David S. Miller" <davem@davemloft.net>, stas.yakovlev@gmail.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Senna Tschudin <peter.senna@collabora.co.uk>
List-Id: linux-scsi@vger.kernel.org

Hello!

On 3/1/2017 6:55 PM, Romain Perier wrote:

> The PCI pool API is deprecated. This commits replaces the PCI pool old

    Commit.

> API by the appropriated function with the DMA pool API. It also updates

    Appropriate perhaps?

> the name of some variables and the content of comments, accordingly.
>
> Signed-off-by: Romain Perier <romain.perier@collabora.com>
> Reviewed-by: Peter Senna Tschudin <peter.senna@collabora.com>
[...]

MBR, Sergei
