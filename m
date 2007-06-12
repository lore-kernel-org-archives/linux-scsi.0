From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 0/3] AHCI Link Power Management
Date: Mon, 11 Jun 2007 19:34:42 -0700
Message-ID: <466E0642.5020506@linux.intel.com>
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com> <466DFDB5.9030901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:49003 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751196AbXFLCgQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jun 2007 22:36:16 -0400
In-Reply-To: <466DFDB5.9030901@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, jeff@garzik.org, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Kristen Carlson Accardi wrote:
>> Hi,
>> This series of patches enables Aggressive Link Power Management for AHCI 
>> devices, as documented in the AHCI spec.  On my laptop (a Lenovo X60), this
>> saves me a full watt of power.  On other systems, reported power savings
>> range from .5-1.5 Watts.  It has been tested by the kind folks at #powertop
>> with similar results.  Please give it a try and let me know what you think.
> 
> I'm not sure about this.  We need better PM framework to support
> powersaving in other controllers and some ahcis don't save much when
> only link power management is used, 

do you have data to support this? The data we have from this patch is 
that it saves typically a Watt of power (depends on the machine of 
course, but the range is 0.5W to 1.5W). If you want to also have an 
even more agressive thing where you want to start disabling the entire 
controller... I don't see how this is in conflict with saving power on 
the link level by "just" enabling a hardware feature ....
