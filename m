From: James Bottomley <jejb@linux.ibm.com>
Subject: Re: [PATCH v2] scsi: smartpqi_init: Reporting 'logical unit failure'
Date: Fri, 01 Mar 2019 07:26:27 -0800
Message-ID: <1551453987.3334.2.camel@linux.ibm.com>
References: <20190227163133.26283-1-e.velu@criteo.com>
         <20190301145832.12735-1-e.velu@criteo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190301145832.12735-1-e.velu@criteo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Erwan Velu <erwanaliasr1@gmail.com>, elliott@hpe.com
Cc: Erwan Velu <e.velu@criteo.com>, Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:MICROSEMI SMART ARRAY SMARTPQI DRIVER (smartpqi)" <esc.storagedev@microsemi.com>, "open list:MICROSEMI SMART ARRAY SMARTPQI DRIVER (smartpqi)" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2019-03-01 at 15:58 +0100, Erwan Velu wrote:
> +			dev_err_ratelimited(&ctrl_info->pci_dev-
> >dev, "received 'logical unit failure' from controller for scsi
> %d:%d:%d:%d\n",
> +							ctrl_info-
> >scsi_host->host_no, device->bus,
> +							device-
> >target, device->lun);

Shouldn't this be a variant of sdev/scmd_printk?  Otherwise it tells
you what disk in the array terms is the problem but not what device in
your actual system is affected.

James
