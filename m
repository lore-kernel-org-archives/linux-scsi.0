From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
Date: Wed, 13 Feb 2008 20:38:55 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802132038320.29154@fbirervta.pbzchgretzou.qr>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>
 <47B1D7A8.8010108@panasas.com> <47B1DA2A.1060904@panasas.com>
 <47B29702.7050503@allied-internet.ag> <47B2B268.1070702@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33919 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbYBMTi4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2008 14:38:56 -0500
In-Reply-To: <47B2B268.1070702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>, =?ISO-8859-15?Q?Sven_K=F6hler?= <skoehler@upb.de>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>


On Feb 13 2008 11:03, Boaz Harrosh wrote:
>> 
>> I've tested this patch now - and it works fine. Now rmmod, halt and 
>> reboot also works.
>> 
>> Stefan Priebe
>> 
>This is grate news Stefan. Thank you very much for all your time
>and effort, with out we could not have fixed all this.

Do you have a git tree with the latest pieces?
