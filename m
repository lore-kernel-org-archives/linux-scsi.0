From: Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH] ISCI: add more PCI IDs
Date: Tue, 30 Apr 2013 10:33:37 -0700
Message-ID: <51800071.1060001@intel.com>
References: <1367327568-12196-1-git-send-email-evgeni@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12224 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760805Ab3D3Rdi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Apr 2013 13:33:38 -0400
In-Reply-To: <1367327568-12196-1-git-send-email-evgeni@debian.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Evgeni Golov <evgeni@debian.org>
Cc: "Dorau, Lukasz" <lukasz.dorau@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>

On 04/30/2013 06:12 AM, Evgeni Golov wrote:
> These are found in e.g. the R2000GZ/GL machines.

Nack. These PCI device IDs are reserved for third party device drivers. 
Most likely that machine has a third party OROM as well.


> ---
>   drivers/scsi/isci/init.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
> index 2839baa..d1ec2bd 100644
> --- a/drivers/scsi/isci/init.c
> +++ b/drivers/scsi/isci/init.c
> @@ -82,12 +82,16 @@ static DEFINE_PCI_DEVICE_TABLE(isci_id_table) = {
>   	{ PCI_VDEVICE(INTEL, 0x1D67),},
>   	{ PCI_VDEVICE(INTEL, 0x1D69),},
>   	{ PCI_VDEVICE(INTEL, 0x1D6B),},
> +	{ PCI_VDEVICE(INTEL, 0x1D6D),},
> +	{ PCI_VDEVICE(INTEL, 0x1D6F),},
>   	{ PCI_VDEVICE(INTEL, 0x1D60),},
>   	{ PCI_VDEVICE(INTEL, 0x1D62),},
>   	{ PCI_VDEVICE(INTEL, 0x1D64),},
>   	{ PCI_VDEVICE(INTEL, 0x1D66),},
>   	{ PCI_VDEVICE(INTEL, 0x1D68),},
>   	{ PCI_VDEVICE(INTEL, 0x1D6A),},
> +	{ PCI_VDEVICE(INTEL, 0x1D6C),},
> +	{ PCI_VDEVICE(INTEL, 0x1D6E),},
>   	{}
>   };
>   


-- 

Dave Jiang
Application Engineer, Storage Divsion
Intel Corp.
dave.jiang@intel.com

