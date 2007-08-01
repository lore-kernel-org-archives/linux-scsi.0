From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Wed, 01 Aug 2007 12:24:44 +0900
Message-ID: <46AFFCFC.7020902@gmail.com>
References: <20070705194909.337398431@intel.com>	<20070705130518.135e4e3c.kristen.c.accardi@intel.com>	<46AE12B6.6090408@garzik.org>	<46AED656.8070407@gmail.com>	<20070731093014.db9e0734.kristen.c.accardi@intel.com>	<46AF794F.1020107@gmail.com> <20070731125849.501443c1.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:23702 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbXHADZ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 23:25:57 -0400
Received: by wa-out-1112.google.com with SMTP id v27so74814wah
        for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 20:25:55 -0700 (PDT)
In-Reply-To: <20070731125849.501443c1.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk

Kristen Carlson Accardi wrote:
>> I don't think the interface you're suggesting is a good one.  Do you?
> 
> I think if it's applicable to SCSI at all it is fine.  If it is not, then
> I think we need to make do with the interface we are given.  I do not think
> we should hold up a feature for libata sysfs integration.

Well, I guess we'll have to agree to disagree here and leave the
decision to James and Jeff.

>>> I can assert that I think ALPM is a good idea,
>>> because I've never had a report of it causing problems.  Windows has 
>>> been using this feature for a very long time - and you have to admit that
>>> they have a pretty large market share.  Nobody is complaining about ALPM
>>> increasing device malfunction, so unless you have proof it seems insane
>>> to nak due to this. 
>> Is ALPM enabled by default?  How do they deal with the performance
>> degradation?
> 
> I believe so, but I'm obviously not privvy to their implementation details.

It would be *really* great if we can find more about how they do it.
How and when it's enabled and on which systems.  Is it possible to find
this out?

-- 
tejun
