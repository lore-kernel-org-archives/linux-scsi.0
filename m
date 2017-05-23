From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH blktests v2 3/3] sg/001: add regression test for syzcaller
 generated GPF in sg_read path
Date: Tue, 23 May 2017 16:25:32 +0200
Message-ID: <491d4221-8d89-8284-0971-d6f0e47b6463@suse.de>
References: <cover.1495201975.git.jthumshirn@suse.de>
 <79600648b662bc8b9e701ff6627986887384585b.1495201975.git.jthumshirn@suse.de>
 <20170522175905.GA17738@vader.DHCP.thefacebook.com>
 <b8de93e9-af4b-d0fc-270e-b938f68688b4@suse.de>
 <f278026c-42f6-9022-f72a-84439141f5d7@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <f278026c-42f6-9022-f72a-84439141f5d7@kernel.dk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Omar Sandoval <osandov@osandov.com>
Cc: Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05/23/2017 04:15 PM, Jens Axboe wrote:
> Add some code to the framework that allows you to get the corresponding
> SG device for a SCSI block device? Make that part of the prepare, skip
> the test if the block device isn't a SCSI dev.

Well the code is already there (in patch 2/3).

I'll pack it into the prepare stage.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
