From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH blktests v2 0/3] Add SCSI generic test group
Date: Wed, 7 Jun 2017 09:03:49 +0200
Message-ID: <17146abe-6286-fdcd-1cdb-d004754f73f2@suse.de>
References: <cover.1495201975.git.jthumshirn@suse.de>
 <20170607064408.GA9840@vader>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170607064408.GA9840@vader>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 06/07/2017 08:44 AM, Omar Sandoval wrote:
> Sorry for the delay, I was chasing down a few Btrfs bugs for the last
> couple of weeks. I applied these with some small changes. I stuck with
> running syzkaller on the scsi-debug device like you had here, we can
> revisit that for future tests if it makes sense to run them on a real
> device. Thanks!

Yes I wanted to go to it tomorrow and send you a v3, I got stuck in NVMe
;-). Thanks for applying it anyways, I'll send a follow up.

	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
