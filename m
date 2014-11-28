From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH 1/1] arcmsr: Notify has sense data report
Date: Fri, 28 Nov 2014 17:57:28 +0800
Message-ID: <1417168648.25477.3.camel@Centos6.3-64>
References: <1417148444.16588.56.camel@Centos6.3-64>
	 <20141128091752.GH4911@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141128091752.GH4911@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, hare@suse.de
Cc: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Thanks to Dan's advice and Hannes' suggestion.
I will revise and resubmit it later.

On Fri, 2014-11-28 at 12:17 +0300, Dan Carpenter wrote:
> On Fri, Nov 28, 2014 at 12:20:44PM +0800, Ching Huang wrote:
> > This patch is relative to http://git.infradead.org/users/hch/scsi-queue.git/tree/refs/heads/drivers-for-3.18:/drivers/scsi/arcmsr
> > 
> 
> Put this information after the --- cut off line so that it is not
> saved in the permanent git log.
> 
> > Setting command status with 'DRIVER_SENSE' except 'CHECK_CONDITION' if we have sense data.
> > 
> > Signed-off-by: Ching Huang <ching2048@areca.com.tw>
> > ---
> 
> <--- Here.  Put it here.
> 
> > 
> > diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
> > --- a/drivers/scsi/arcmsr/arcmsr.h	2014-09-19 11:04:41.845100000 +0800
> > +++ b/drivers/scsi/arcmsr/arcmsr.h	2014-11-28 10:54:30.000000000 +0800
> > @@ -52,7 +52,7 @@ struct device_attribute;
> >  	#define ARCMSR_MAX_FREECCB_NUM	320
> >  #define ARCMSR_MAX_OUTSTANDING_CMD	255
> 
> regards,
> dan carpenter
> 
