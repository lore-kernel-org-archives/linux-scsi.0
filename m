From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: hosts: remove redundant assingment of
 shost->use_blk_mq
Date: Tue, 03 Apr 2018 09:40:52 +0200
Message-ID: <1522741252.3709.0.camel@suse.de>
References: <20180402093749.6862-1-jthumshirn@suse.de>
         <4c62b8f8da1175ddcdcdf0a234dacbf620d73060.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4c62b8f8da1175ddcdcdf0a234dacbf620d73060.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-04-02 at 13:53 +0000, Bart Van Assche wrote:
> A similar patch has already been queued by Martin. See also
> https://patchwork.kernel.org/patch/10313569/.

Ah OK, fine then :-)
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
