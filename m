From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: linux-scsi list filtering
Date: Mon, 10 Jan 2005 10:41:24 +0200
Message-ID: <20050110084124.GL8704@mea-ext.zmailer.org>
References: <41E1B79A.3080706@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.zmailer.org ([62.78.96.67]:18632 "EHLO mail.zmailer.org")
	by vger.kernel.org with ESMTP id S262155AbVAJIl1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 03:41:27 -0500
Content-Disposition: inline
In-Reply-To: <41E1B79A.3080706@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Mon, Jan 10, 2005 at 09:00:42AM +1000, Douglas Gilbert wrote:
> Date:	Mon, 10 Jan 2005 09:00:42 +1000
> From:	Douglas Gilbert <dougg@torque.net>
> To:	linux-scsi@vger.kernel.org
> Cc:	James.Bottomley@SteelEye.com
> Subject: linux-scsi list filtering
> Content-Type: text/plain; charset=ISO-8859-1; format=flowed

You really should ask this kind of questions from
   <postmaster@vger.kernel.org>
as you can read at  http://vger.kernel.org/


Possibly it is this one:

   Subject: BOUNCE linux-scsi@vger.kernel.org:
            global taboo header: /charset=.*windows-/i


That pattern bites on quite a lot of spams and viruses, but
unfortunately also on some amount of legitimate list messages.

Reviewing past weeks worth of monitoring logs, it does appear
that of 10-20 daily hits with that patterns there is always
also some other pattern present when it genuinely is spam/virus/junk.

I will now remove that block, and we shall see, what
leaks thru...  (if any.)


> Twice yesterday I tried to reply to the "spin down idle
> SATA disks" thread. The first was sent to the original
> poster and cc-ed to this list. When my reply didn't appear
> after 12 hours, I resent my reply directly to this list.
> Neither appeared on the linux-scsi list (at least not via
> my subscription or the marc.theaimsgroup.com archive).
> 
> Obviously the original poster received my mail as he has
> recently responded to the list. That tends to suggest
> that incoming mail is being filtered by the linux-scsi
> list.
> 
> Is anyone else experiencing this type of behaviour?
> 
> Doug Gilbert

/Matti Aarnio -- one of  <postmaster@vger.kernel.org>
