From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Marvell SATA status
Date: Tue, 17 Jan 2006 19:07:35 -0500
Message-ID: <43CD86C7.80806@pobox.com>
References: <43CD67E1.7080703@int.gl3>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:38320 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932455AbWARAHj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 19:07:39 -0500
In-Reply-To: <43CD67E1.7080703@int.gl3>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Bakuwel <jan.bakuwel@int.greenpeace.org>
Cc: linux-scsi@vger.kernel.org

Jan Bakuwel wrote:
> Hi,
> 
> I need to decide whether to add an additional 3ware SATA RAID adapter to
> a server or to utilise the onboard Marvell SATA RAID adapter

Note that the Marvell chip is not RAID.  See 
http://linux.yyz.us/sata/faq-sata-raid.html


> (preferred). The Marvell driver (2.6.15.1) is "highly experimental" and
> I see no traffic mentioning this driver since Sept last year... I was
> wondering what the current status is. If it's still alive I'm obviously
> offering to help debug it...

You will have better luck on the linux-ide list, though there admittedly 
aren't a lot of sata_mv hackers.

Patches are certainly welcome.  sata_mv needs some more errata 
workarounds before it could be said to be ready for production.

	Jeff



