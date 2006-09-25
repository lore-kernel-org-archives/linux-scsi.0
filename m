From: Israel Mouton <lebanon87@myrealbox.com>
Subject: Re: Ultra320 drive detected as narrow SCSI by adapter
Date: Sun, 24 Sep 2006 19:57:09 -0700 (PDT)
Message-ID: <6479563.post@talk.nabble.com>
References: <6478431.post@talk.nabble.com> <1159147910.3462.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.nabble.com ([72.21.53.35]:48343 "EHLO talk.nabble.com")
	by vger.kernel.org with ESMTP id S1750879AbWIYC5J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Sep 2006 22:57:09 -0400
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1GRgeb-0003Ad-88
	for linux-scsi@vger.kernel.org; Sun, 24 Sep 2006 19:57:09 -0700
In-Reply-To: <1159147910.3462.16.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I don't seem to have a "/sys/class/spi_transport/" directory.  When the
system boots the LSI board detects it as a narrow.  I was wondering if it is
perhaps possible to reconfigure it under Linux at all?


James Bottomley wrote:
> 
> On Sun, 2006-09-24 at 17:20 -0700, Israel Mouton wrote:
>> scsi0 : ioc0: LSI53C1030, FwRev=01030f00h, Ports=1, MaxQ=222, IRQ=9
>>   Vendor: MAXTOR    Model: ATLAS10K5_147SCA  Rev: JNX0
>>   Type:   Direct-Access                      ANSI SCSI revision: 03
>> SCSI device sda: 287332384 512-byte hdwr sectors (147114 MB)
> 
> It's not doing domain validation, which configures the device ... that
> could be a driver bug, but I know of no outstanding problems in that
> area.
> 
> You can try to re-trigger it with 
> 
> echo 1 > /sys/class/spi_transport/target0:0:0/revalidate
> 
> and see what happens?
> 
> Thanks,
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
View this message in context: http://www.nabble.com/Ultra320-drive-detected-as-narrow-SCSI-by-adapter-tf2328646.html#a6479563
Sent from the linux-scsi mailing list archive at Nabble.com.

