From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [SUBJECT CHANGE]: megaraid unified driver version 2.20.0.0-al
 pha1
Date: Wed, 25 Feb 2004 21:27:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <403D597C.4020708@pobox.com>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC3E7@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:22481 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262605AbUBZC11
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 21:27:27 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC3E7@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, 'Arjan van de Ven' <arjanv@redhat.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "'matt_domsch@dell.com'" <matt_domsch@dell.com>, 'Paul Wagland' <paul@wagland.net>, Matthew Wilcox <willy@debian.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Mukker, Atul wrote:
>>given that they are completely different from the controller we know
>>as megaraid today this is an extremly bad idea.  Just put it 
>>into an driver
>>of their own, e.g. mptraid
> 
> Although, this simplifies the development and maintenance effort, having a
> single driver to drive both controllers or two independent drivers is not
> always our decision. Most often, it would be Dell's preference. 

If the hardware is similar, a single driver is OK.

If the hardware is not similar, the preference is for separate drivers.

Shared code in a third module, a "library module", is an acceptable 
solution.  modprobe automatically loads dependent modules, so users 
running "modprobe driver1" or "modprobe driver2" would automatically 
load the shared library module.

	Jeff



