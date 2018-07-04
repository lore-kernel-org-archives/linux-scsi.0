From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [RFC] scsi: switch to scsi-mq by default
Date: Wed, 4 Jul 2018 10:49:12 +0200
Message-ID: <20180704084912.u7ow3l6yh34wr5ip@linux-x5ow.site>
References: <20180703065413.6098-1-jthumshirn@suse.de>
 <7ab21471b799d2a60ccfd8579b2548f58915568a.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7ab21471b799d2a60ccfd8579b2548f58915568a.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hch@lst.de" <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 03, 2018 at 11:21:18PM +0000, Bart Van Assche wrote:
> Please include references to commits cbe7dfa26eee ("Revert "scsi:
> default to scsi-mq"") and 5c279bd9e406 ("scsi: default to scsi-mq").
> I think it's a good idea to mention that suspend/resume now works
> with scsi-mq.

That's actually a good idea. Will be sending out a non-rfc version
with these changelog changes and Reviews/Acks applied.
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
