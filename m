From: Israel Mouton <lebanon87@myrealbox.com>
Subject: Re: Ultra320 drive detected as narrow SCSI by adapter
Date: Sun, 24 Sep 2006 21:46:51 -0700 (PDT)
Message-ID: <6480232.post@talk.nabble.com>
References: <6478431.post@talk.nabble.com> <1159147910.3462.16.camel@mulgrave.il.steeleye.com> <6479563.post@talk.nabble.com> <1159155135.3462.22.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.nabble.com ([72.21.53.35]:20618 "EHLO talk.nabble.com")
	by vger.kernel.org with ESMTP id S1751688AbWIYEqw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 00:46:52 -0400
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1GRiMl-0005WT-Ud
	for linux-scsi@vger.kernel.org; Sun, 24 Sep 2006 21:46:51 -0700
In-Reply-To: <1159155135.3462.22.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


It is 2.6.16; however, it is the Debian version.  I did compile it from
source.  Perhaps there is a chance I left something unchecked I should have
compiled in?

James Bottomley wrote:
> 
> On Sun, 2006-09-24 at 19:57 -0700, Israel Mouton wrote:
>> I don't seem to have a "/sys/class/spi_transport/" directory.  When the
>> system boots the LSI board detects it as a narrow.  I was wondering if it
>> is
>> perhaps possible to reconfigure it under Linux at all?
> 
> Erm, what kernel is this?  The generic transport class, which does allow
> you to configure this type of thing has been present in the kernel since
> 2.6.16
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
View this message in context: http://www.nabble.com/Ultra320-drive-detected-as-narrow-SCSI-by-adapter-tf2328646.html#a6480232
Sent from the linux-scsi mailing list archive at Nabble.com.

