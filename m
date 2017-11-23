From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH 2/3] scsi: arcmsr: Add driver module parameter
 msix_enable
Date: Fri, 24 Nov 2017 03:11:25 +0800
Message-ID: <1511464285.4370.2.camel@Centos6.3-64>
References: <1511400674.9832.23.camel@Centos6.3-64>
         <20171123114336.bnekgwbrdbx7kvnn@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171123114336.bnekgwbrdbx7kvnn@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-11-23 at 14:43 +0300, Dan Carpenter wrote:
> On Thu, Nov 23, 2017 at 09:31:14AM +0800, Ching Huang wrote:
> > @@ -829,12 +833,15 @@ arcmsr_request_irq(struct pci_dev *pdev,
> >  	unsigned long flags;
> >  	int nvec, i;
> >  
> > +	if (msix_enable == 0)
> > +		goto msi_int0;
> 
> I feel like this goto is not very beautiful, but I can't actually apply
> this patch?  Which tree is this written against?  I'm using linux-next.
> 
This patch is apply to https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/tree/?h=4.16/scsi-queue

> regards,
> dan carpenter
> 
> 
