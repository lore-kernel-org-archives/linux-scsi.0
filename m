From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: Kernel crash with 4.10 trying to remove scsi disks
Date: Mon, 27 Feb 2017 11:35:33 +0100
Message-ID: <fd33b84d-7362-2a6a-a2c8-6cc62ba00510@suse.de>
References: <48a44b52-f721-709f-10e1-6787a0774515@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49375 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751778AbdB0Kx6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Feb 2017 05:53:58 -0500
In-Reply-To: <48a44b52-f721-709f-10e1-6787a0774515@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Farhan Ali <alifm@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@de.ibm.com>

On 02/24/2017 04:07 PM, Farhan Ali wrote:
> Hello,
> 
> I have noticed a kernel crash with 4.10 kernel in our s390 environment,
> running a test trying to remove scsi disks. Here is a snippet of the
> kernel crash message:

Hi Farhan,

Is this crash newly introduced with 4.10? Do you maybe have a chance to
bisect it?

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
