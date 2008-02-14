From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
Date: Thu, 14 Feb 2008 17:58:11 +0200
Message-ID: <47B46513.8020206@panasas.com>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com> <47B1D7A8.8010108@panasas.com> <47B1DA2A.1060904@panasas.com> <47B29702.7050503@allied-internet.ag> <47B2B268.1070702@panasas.com> <Pine.LNX.4.64.0802132038320.29154@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27459 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753011AbYBNP7o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 10:59:44 -0500
In-Reply-To: <Pine.LNX.4.64.0802132038320.29154@fbirervta.pbzchgretzou.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>, =?ISO-8859-1?Q?Sven_K=F6hler?= <skoehler@upb.de>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>

On Wed, Feb 13 2008 at 21:38 +0200, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> On Feb 13 2008 11:03, Boaz Harrosh wrote:
>>> I've tested this patch now - and it works fine. Now rmmod, halt and 
>>> reboot also works.
>>>
>>> Stefan Priebe
>>>
>> This is grate news Stefan. Thank you very much for all your time
>> and effort, with out we could not have fixed all this.
> 
> Do you have a git tree with the latest pieces?
No, scsi-misc I guess ;)

I could put it here:
git://git.bhalevy.com/open-osd gdth

branch give me an hours

Boaz
