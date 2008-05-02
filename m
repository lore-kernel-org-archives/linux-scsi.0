From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections
Date: Fri, 02 May 2008 17:01:12 +0200
Message-ID: <481B2CB8.2000307@gmail.com>
References: <1209657362-20300-1-git-send-email-jirislaby@gmail.com>	 <20080501142305.77433e50.akpm@linux-foundation.org>	 <481A3781.8080100@gmail.com>	 <1209679559.14864.33.camel@localhost.localdomain>	 <20080501153048.2a8d356f.akpm@linux-foundation.org> <1209740170.3121.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:29512 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbYEBPBK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 11:01:10 -0400
Received: by fg-out-1718.google.com with SMTP id 19so963157fgg.17
        for <linux-scsi@vger.kernel.org>; Fri, 02 May 2008 08:01:07 -0700 (PDT)
In-Reply-To: <1209740170.3121.24.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

James Bottomley napsal(a):
>>> could we not at least make the machinery do something vaguely
>>> useful and expand it to confine the pm routines to sections which can be
>>> discarded if CONFIG_PM is n?
>> a) it would need to be discarded at link-time, ideally.
> 
> Yes, the same way the exit sections are: as linker discards.  We also
> have the mechanics for runtime discards which is useful for modules

No it doesn't, exits are discarded at runtime only. At least on x86.
