From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] sym53c8xx: Avoid undefined behaviour in
 drivers/scsi/sym53c8xx_2/sym_hipd.c:762
Date: Fri, 11 Aug 2017 09:24:13 +0200
Message-ID: <20170811072413.GB3744@linux-x5ow.site>
References: <20170810190849.GA12659@p100.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-parisc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170810190849.GA12659@p100.box>
Sender: linux-parisc-owner@vger.kernel.org
To: Helge Deller <deller@gmx.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 10, 2017 at 09:08:49PM +0200, Helge Deller wrote:
> On parisc I see this UBSAN warning with a sym53c896:
> 
>  UBSAN: Undefined behaviour in ./drivers/scsi/sym53c8xx_2/sym_hipd.c:762:24
>  index -1903078336 is out of range for type 'u32 [7]'
> 
> Avoid this warning by switching to dev64_ul().
                            div64_ul() ^

Otherwise,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
