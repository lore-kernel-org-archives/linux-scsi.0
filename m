From: =?UTF-8?B?6YSt5a6I6KyZ?= <nick.cheng@areca.com.tw>
Subject: Re: [PATCH 1/5] arcmsr: Re-name the HBA Type
Date: Thu, 15 Nov 2012 23:07:52 +0800
Message-ID: <CAGUPPa6eL-_vKVjCkrHihAhKkniS0E4buWyRPuR4b-qmoUBPwA@mail.gmail.com>
References: <85E5FCE3D4AD4A2D9A3DE6E64060AF05@arecaaebe11fae>
	<1352988719.2578.5.camel@dabdike>
	<CAGUPPa5rmZoG0tf3o6GSqcjUwdnd5+CPfy1WkSoO0doFv6eh4Q@mail.gmail.com>
	<1352991622.2578.9.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:58708 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768218Ab2KOPHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2012 10:07:54 -0500
Received: by mail-la0-f46.google.com with SMTP id h6so1314617lag.19
        for <linux-scsi@vger.kernel.org>; Thu, 15 Nov 2012 07:07:52 -0800 (PST)
In-Reply-To: <1352991622.2578.9.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

OK. I will fix it.
Thank you,
2012/11/15 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Thu, 2012-11-15 at 22:53 +0800, =E9=84=AD=E5=AE=88=E8=AC=99 wrote:
>> Hi James,
>> You got these errors/warnings before or after you apply these 5 patc=
hes?
>
> I got all of this lot from patch 1/5 only.  Please fix at least the
> errors and the warnings that go to whitespace issues.  I don't really
> care about printk(KERN_ERR vs pr_err( or lines over 80 characters.
>
> James
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
