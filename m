From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/3] scsi: arcmsr: Add driver module parameter msix_enable
Date: Thu, 23 Nov 2017 14:43:36 +0300
Message-ID: <20171123114336.bnekgwbrdbx7kvnn@mwanda>
References: <1511400674.9832.23.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1511400674.9832.23.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 23, 2017 at 09:31:14AM +0800, Ching Huang wrote:
> @@ -829,12 +833,15 @@ arcmsr_request_irq(struct pci_dev *pdev,
>  	unsigned long flags;
>  	int nvec, i;
>  
> +	if (msix_enable == 0)
> +		goto msi_int0;

I feel like this goto is not very beautiful, but I can't actually apply
this patch?  Which tree is this written against?  I'm using linux-next.

regards,
dan carpenter
