From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [ANNOUNCE][RELEASE]: megaraid unified driver version 2.20.0.B
 1
Date: Fri, 16 Apr 2004 15:34:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40803553.2030403@pobox.com>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC53D@exa-atlanta.se.lsil.com> <40803154.3070707@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:36571 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263653AbUDPTfA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 15:35:00 -0400
In-Reply-To: <40803154.3070707@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, "'Matt_Domsch@dell.com'" <Matt_Domsch@dell.com>, "'paul@kungfoocoder.org'" <paul@kungfoocoder.org>, "'James.Bottomley@SteelEye.com'" <James.Bottomley@SteelEye.com>, "'arjanv@redhat.com'" <arjanv@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>

Jeff Garzik wrote:
> If there is a static maximum of scbs for megaraid hardware, dynamically 
> allocating scbs in ->queuecommand is a waste of time.
> 
> In my drivers, I pre-allocate driver-specific per-request structures -- 
> just like the SCSI layer does ;-)

Slight correction... it looks like SCSI dynamically allocates requests 
these days.

That doesn't change my core argument, however.

	Jeff



