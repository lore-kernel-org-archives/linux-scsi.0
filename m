From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: aic79xx and RAID ?
Date: Thu, 01 Dec 2005 06:39:25 -0500
Message-ID: <438EE0ED.7000605@pobox.com>
References: <20051201102039.GA23336@danisch.de> <1133433450.2853.25.camel@laptopd505.fenrus.org> <20051201104805.GA3893@danisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:451 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932167AbVLALjf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2005 06:39:35 -0500
In-Reply-To: <20051201104805.GA3893@danisch.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hadmut Danisch <hadmut@danisch.de>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org

Hadmut Danisch wrote:
> A software raid controller?  Never heard of such a beast before. 
> 
> 
> I always thought that there are exactly two ways to do raid, 
> one way is to have it all hidden in the controller, which makes the
> RAID mirror appear as just a single disk to the kernel, 
> and the other way is to use the kernel software raid (configured with
> mdadm). 
> 
> I've never heard of a software raid controller, where the kernel must
> do the work itself. After all, what's the controller's job and
> why is it called a RAID controller then? 

Marketing.

Read http://linux.yyz.us/sata/faq-sata-raid.html

	Jeff


