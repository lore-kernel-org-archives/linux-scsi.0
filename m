From: Alex <mysqlstudent@gmail.com>
Subject: Re: aacraid problems on 2.6.35-rc3
Date: Wed, 30 Jun 2010 10:57:44 -0400
Message-ID: <AANLkTinRg1WIRWIBE1odKkvbECBPLPUoY2mVKmAjqpKZ@mail.gmail.com>
References: <AANLkTimvQtYPh_6ZeKiGz2-eZf_pVy6N7TwEeXCoq0Iv@mail.gmail.com>
	<1277909662.2839.17.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47482 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab0F3O5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jun 2010 10:57:46 -0400
Received: by gyd12 with SMTP id 12so444221gyd.19
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jun 2010 07:57:45 -0700 (PDT)
In-Reply-To: <1277909662.2839.17.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

>> It only prints the following when booting:
>>
>> Adaptec aacraid driver 1.1-5[2456]-ms
>
> That driver comes from a rather old kernel (2.6.29 or before). =A0Cou=
ld
> you try with a modern version (which should print 1.1-5[26400]-ms jus=
t
> in case the problem got fixed in the interim.

Yes, my apologies. This was from the working kernel, which is 2.6.27.
I am working with 2.6.35-rc3.

>> The dmesg output from a working system is here:
>>
>> http://pastebin.com/0AnVBV7s
>
> This trace shows your system won't configure interrupts correctly
> without ACPI ... if ACPI isn't working, more than just the aacraid wi=
ll
> be non functional. =A0A dmesg of the failing system would be definiti=
ve in
> diagnosing this.

How can I do this? The kernel panics without mounting a filesystem.

Which are the ACPI options that I should configure?

Thanks again,
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
