From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Marvell SATA status
Date: Wed, 18 Jan 2006 12:32:07 -0500
Message-ID: <43CE7B97.7090303@pobox.com>
References: <43CD67E1.7080703@int.gl3> <43CD86C7.80806@pobox.com> <43CE7558.3060505@int.gl3>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:26806 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751401AbWARRcP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jan 2006 12:32:15 -0500
In-Reply-To: <43CE7558.3060505@int.gl3>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Bakuwel <jan.bakuwel@int.greenpeace.org>
Cc: linux-scsi@vger.kernel.org

Jan Bakuwel wrote:
> Hoi Jeff,
> 
>> Note that the Marvell chip is not RAID.  See 
>> http://linux.yyz.us/sata/faq-sata-raid.html
> 
> 
> The Marvell chip isn't listed on that page unless my eye sight is 
> deterioting :-)

Yes but you get the general point.


> The BIOS identifies it as an Adaptec HostRAID 6041 controller (?), 

"HostRAID" == software RAID


> allows for setting up the arrays etc, however, 'lspci -vv' identifies it 
> as a Marvell Technology  MV88SX6041 RAID controller.
> 
> It could indeed be software RAID by controller, but as far as the OS is 
> concerned the controller presents the array to the OS as a single disc...

Incorrect.  The driver sees only the individual discs.

	Jeff


