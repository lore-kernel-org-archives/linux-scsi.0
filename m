From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH blktests v2 3/3] sg/001: add regression test for syzcaller
 generated GPF in sg_read path
Date: Tue, 23 May 2017 08:58:32 +0200
Message-ID: <b8de93e9-af4b-d0fc-270e-b938f68688b4@suse.de>
References: <cover.1495201975.git.jthumshirn@suse.de>
 <79600648b662bc8b9e701ff6627986887384585b.1495201975.git.jthumshirn@suse.de>
 <20170522175905.GA17738@vader.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170522175905.GA17738@vader.DHCP.thefacebook.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05/22/2017 07:59 PM, Omar Sandoval wrote:
> This looks much better, thanks! One question for you: is there any value
> in running this on specific test devices (i.e., changing test() to
> test_device() and using "$TEST_DEV" instead of a scsi-debug device), or
> would it be a waste of time since it's just exercising generic code?

That's just generic code. All I need is a SCSI device so I get a /dev/sg
device node.

One could do a check if $TEST_DEV is a SCSI device and have a fall-back
to scsi_debug if it isn't, but I'm not sure if this isn't just a waste
of time.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
