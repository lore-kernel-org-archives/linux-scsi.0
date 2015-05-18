From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v5 0/9] snic:initial submission of snic driver for Cisco
 SCSI HBA
Date: Mon, 18 May 2015 07:35:17 -0700
Message-ID: <1431959717.2256.2.camel@HansenPartnership.com>
References: <1429694642-22309-1-git-send-email-nmusini@cisco.com>
	 <1431704986.2295.2.camel@HansenPartnership.com>
	 <D17C16FC.25A05%nmusini@cisco.com>
	 <1431707688.26877.3.camel@HansenPartnership.com>
	 <D17F6556.25AFA%nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57751 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751488AbbEROfW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 May 2015 10:35:22 -0400
In-Reply-To: <D17F6556.25AFA%nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>

On Mon, 2015-05-18 at 04:21 +0000, Narsimhulu Musini (nmusini) wrote:
> Hi James,
> 
>      Added dependency in Kconfig for x86 to avoid its inclusion on other
> architectures. Will it be help, if it is changed to x86_64?.

Not really.  The problem is that if you introduce code that isn't clean
from the bit width or endianness perspective, the static checkers will
pick it up and flag it and we'll just get a flood of errors reported in
the driver.  Plus from the maintenance perspective, the code needs to be
clean (which is why the static checkers are looking for this).

James


