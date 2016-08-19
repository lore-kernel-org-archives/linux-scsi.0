From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v4 2/3] ses: use scsi_is_sas_rphy instead of
 is_sas_attached
Date: Fri, 19 Aug 2016 08:53:09 +0200
Message-ID: <20160819065309.h7jkkxbiopgikl6w@c203.arch.suse.de>
References: <cover.1471426748.git.jthumshirn@suse.de>
 <34f1f359e3a7c5ca573c3ca52b110c13666fc22e.1471426748.git.jthumshirn@suse.de>
 <1471534911.2389.25.camel@linux.vnet.ibm.com>
 <1471536522.2389.27.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1471536522.2389.27.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 18, 2016 at 09:08:42AM -0700, James Bottomley wrote:
> And please fix your scripts or just use the standard ones:

Hmmm, I'm not using a script at all but pure git send-email. I'll have
a look into it.

> 
> Cc: stable@vger.kernel.org, #@suse.de, v4.5+@suse.de,
>   
> I'm tired of getting two bounces every time I reply to this thread.
> 
> James
> 

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
