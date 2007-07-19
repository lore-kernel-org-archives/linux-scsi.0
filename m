From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patch 0/4] aha152x.c - Cleanup, need help in testing and auditing
Date: Thu, 19 Jul 2007 18:57:50 +0300
Message-ID: <469F89FE.4080900@panasas.com>
References: <4695F76F.5000305@panasas.com>	<20070712135750.2a4a4a54.rdunlap@xenotime.net>	<469B38CC.50501@panasas.com>	<20070717171607.ffc278eb.rdunlap@xenotime.net>	<469DDD74.2060208@panasas.com>	<20070718103320.4b6ad7b3.rdunlap@xenotime.net>	<20070718145818.8eebbd66.rdunlap@xenotime.net>	<20070718194335.e21a01e5.rdunlap@xenotime.net>	<20070718200315.3adcd194.rdunlap@xenotime.net>	<469F616D.1000909@panasas.com> <20070719083719.33d8994c.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5536 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965148AbXGSP6L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 11:58:11 -0400
In-Reply-To: <20070719083719.33d8994c.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dougg@torque.net>, scsi <linux-scsi@vger.kernel.org>, =?ISO-8859-1?Q?=22J=FCrgen_E=2E_Fischer=22?= <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Randy Dunlap wrote:
> 
> Yes, this problem has been around forever AFAIK.  You didn't add
> to it.
Do we need to file a bug report in Bugzilla or something, so people have a 
documentation of the work-around, until it is fixed?

I think that for now I will wrap it up as it is. Could you send me the right
BUG_ON() in place, with a printk pointing users to a solution? and I'll 
redo all the patches.

>>
>> One more thing if I may? Do you have at hand an old Zip cartridge that 
>> has bad sectors or other errors on it. My motivation is to exercise the
>> Sense return code-path. I would like to make sure that its doing the 
>> expected. It is the part that changed the most.
>> I will try to look if there is a way to send a scsi_read using sg3_utils that 
>> will read passed the media capacity, and will trigger a short read. I guess
>> on an unmounted device. Douglas?
> 
> No, I don't have any bad media that I know of.
> I suggest that you look into the "Fault-injection framework"
> (CONFIG_FAULT_INJECTION) to see if it can inject some errors for you.
> 
  Oh, I didn't realize there is one. OK nice I will look into it, thanks.
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

Boaz
