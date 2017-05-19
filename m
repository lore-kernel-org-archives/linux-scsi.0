From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH blktests 0/3] Add SCSI generic test group
Date: Fri, 19 May 2017 08:41:55 +0200
Message-ID: <8762b307-4001-7509-5dd6-74ad4fe8ccc2@suse.de>
References: <cover.1495109149.git.jthumshirn@suse.de>
 <20170518131928.GA26060@infradead.org>
 <94150f71-5bbb-2ee2-b7d4-d0f2f7124684@suse.de>
 <20170518224645.GD26871@vader.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170518224645.GD26871@vader.DHCP.thefacebook.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05/19/2017 12:46 AM, Omar Sandoval wrote:
> Looking at this some more, it seems like the syzkaller reproducer always
> bangs on /dev/sg0. How hard would it be to adapt it to run on the sg
> device for every test device instead?

Can't be too hard I guess ;-).

Maybe I can even clean it up a bit so it compiles with the "-Wall
-Wextra -Werror" trinity.

I'll send you a v2 once I'm done with it (and all other comments).

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
