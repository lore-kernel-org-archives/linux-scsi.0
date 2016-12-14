From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: Samsung SSD 1.92TB PM863 Enterprise 2.5" SATA3 errors withc
 stable 4.4.34
Date: Wed, 14 Dec 2016 13:22:01 +0100
Message-ID: <20161214122201.GB6279@linux-x5ow.site>
References: <CACaajQsKcHJsaUvNo_YTf6UNYR4F2Vi0E6pMUmB1zLpAQg=4ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACaajQsKcHJsaUvNo_YTf6UNYR4F2Vi0E6pMUmB1zLpAQg=4ug@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 14, 2016 at 03:07:48PM +0300, Vasiliy Tolstov wrote:
> Hi! I have stable problems with all Samsung SSD drivers like PM863 and
> EVO 850 Pro.
> 
> Time after time scsi bus reset link with messages:
> [ 2477.973617] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
> action 0xe frozen
> [ 2477.975036] ata1: irq_stat 0x00400040, connection status changed
> [ 2477.976396] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }

Random shot in the dark, have you tried changing the cable?
HostInt: HBA Internal error
PHYRdyChg: PhyRdy signal changed state 
10B8B: 10b to 8b decoding error occurred
DevExch: Device presence has changed

This could indicate a problem with the cabling and/or connectors.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
