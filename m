From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 4/6] bsg: refactor ioctl to use regular BSG-command
 infrastructure for SG_IO
Date: Fri, 11 Aug 2017 00:12:03 +0200
Message-ID: <20170810221203.GB918@bblock-ThinkPad-W530>
References: <cover.1502120928.git.bblock@linux.vnet.ibm.com>
 <ce1d611619cb54c6ff033beab8337ecee29d12d7.1502120928.git.bblock@linux.vnet.ibm.com>
 <20170810082456.GI4841@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170810082456.GI4841@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Steffen Maier <maier@linux.vnet.ibm.com>, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 10, 2017 at 10:24:56AM +0200, Johannes Thumshirn wrote:
> On Wed, Aug 09, 2017 at 04:11:18PM +0200, Benjamin Block wrote:
> > +	return 0 == (bc->hdr.flags & BSG_FLAG_Q_AT_TAIL);
> 
> return !(bc->hdr.flags & BSG_FLAG_Q_AT_TAIL); and make the function return
> bool? I have to admit, this is the 1st time I have seen the above construct.
> 

Hmm yeah, odd. To be honest, I just copied the expression so that it is
obvious that no behavior changed, but just the place. I'll replace it
with what you suggest.



                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
