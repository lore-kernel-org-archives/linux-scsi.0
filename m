From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v5 0/9] snic:initial submission of snic driver for Cisco
 SCSI HBA
Date: Fri, 15 May 2015 09:34:48 -0700
Message-ID: <1431707688.26877.3.camel@HansenPartnership.com>
References: <1429694642-22309-1-git-send-email-nmusini@cisco.com>
	 <1431704986.2295.2.camel@HansenPartnership.com>
	 <D17C16FC.25A05%nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49544 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbbEOQe6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 May 2015 12:34:58 -0400
In-Reply-To: <D17C16FC.25A05%nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>

On Fri, 2015-05-15 at 16:08 +0000, Narsimhulu Musini (nmusini) wrote:
> Hi James,
> 
> >>This doesn't build on 32 bits.  Is it supposed to be 64 bit only?
> Yes please, x86_64 arch only.

For the kernel, we don't usually accept architectural restrictions.
You're perfectly entitled to support only the architectures you wish
(and put a warning in the driver if you want) but we do need the code to
be endian and bitwidth clean because we find it helps with maintenance
and checking (the ppc build systems pick up quite a few snafus that the
x86 ones don't).

James


