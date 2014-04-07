From: David Miller <davem@davemloft.net>
Subject: Re: esp_scsi QTAG in FAS216
Date: Sun, 06 Apr 2014 23:39:24 -0400 (EDT)
Message-ID: <20140406.233924.1271522688406769406.davem@davemloft.net>
References: <5231DF69.6070807@aalto.fi>
	<20140404.162830.1700547572091852195.davem@davemloft.net>
	<CAOmrzkL_6Y2RhpKANmTEWL53-6Ts+PF9Hhk_4Fh1s0wx7f_NhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:47765 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbaDGDj1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Apr 2014 23:39:27 -0400
In-Reply-To: <CAOmrzkL_6Y2RhpKANmTEWL53-6Ts+PF9Hhk_4Fh1s0wx7f_NhQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: schmitzmic@gmail.com
Cc: tuomas.vainikka@aalto.fi, geert@linux-m68k.org, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, jongk@linux-m68k.org

From: Michael Schmitz <schmitzmic@gmail.com>
Date: Mon, 7 Apr 2014 08:33:12 +1200

> Hello Dave, Tuomas,
> 
>>> Also, looking at the timeout formulae in the old NCR53C9x.c driver,
>>> the values would be different for FAS216. Why was this dropped from
>>> the modern esp_scsi?
>>
>> I've never seen a formula for any ESP or FAS chip for the timeout
>> other than the one mentioned in huge comment in
>> esp_set_clock_params(), although I do see the 7668 instead of 8192
>> factor being used in the old NCR53C9x driver.
> 
> I haven't gone far enough back in the 53C9x revision history to be
> certain. but it would seem to me that Kars de Jong added that FAS
> special case.
> 
> Can you confirm that, Kars? Any recollection as to the reason?

Just as another reference point, I looked at the FreeBSD 'esp' driver
and it also uses the 8192 factor for all chips, including FAS216.
