From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 0/3] AHCI Link Power Management
Date: Mon, 11 Jun 2007 23:18:24 -0400
Message-ID: <466E1080.4070504@garzik.org>
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com> <466E0642.5020506@linux.intel.com> <466E0F30.3000700@garzik.org> <466E0F28.3040701@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <466E0F28.3040701@linux.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Tejun Heo <htejun@gmail.com>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> Jeff Garzik wrote:
>> SATA standard defines lower power phy states.  So the same argument 
>> you're using for AHCI applies there too -- "just" enabling an existing 
>> hardware feature.

> yes I'm not arguing against that. I was trying to find out (and 
> suggest-unless-proven-otherwise) that the 2 are not exclusive or 
> conflicting... in fact I assume both are wanted concurrently.

Yes and no.  As I understand it, AHCI's capability is an automatic 
version of what standard SATA phys provide manually.  In AHCI's case, 
the hardware automatically manages the link power, possibly cycling it 
hundreds of times per second.  In the standard case, software must 
determine when a different power state is appropriate based on current 
conditions, and update the phy appropriately.

	Jeff



