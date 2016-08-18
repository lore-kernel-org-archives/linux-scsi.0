From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/3] ses: use scsi_is_sas_rphy instead of
 is_sas_attached
Date: Thu, 18 Aug 2016 09:08:42 -0700
Message-ID: <1471536522.2389.27.camel@linux.vnet.ibm.com>
References: <cover.1471426748.git.jthumshirn@suse.de>
	 <34f1f359e3a7c5ca573c3ca52b110c13666fc22e.1471426748.git.jthumshirn@suse.de>
	 <1471534911.2389.25.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471534911.2389.25.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

And please fix your scripts or just use the standard ones:

Cc: stable@vger.kernel.org, #@suse.de, v4.5+@suse.de,
  
I'm tired of getting two bounces every time I reply to this thread.

James
