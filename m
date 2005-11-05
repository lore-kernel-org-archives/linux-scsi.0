From: Ashutosh Naik <ashutosh.lkml@gmail.com>
Subject: Re: [stable] Re: [PATCH] scsi - Fix Broken Qlogic ISP2x00 Device Driver
Date: Sat, 5 Nov 2005 10:26:16 +0530
Message-ID: <c216304e0511042056t79f07d0bi7b4c763838b2c401@mail.gmail.com>
References: <81083a450511012313v25e292duf7b64da0ebf07835@mail.gmail.com>
	 <20051102080711.GB626@plapn>
	 <20051102082142.GW5856@shell0.pdx.osdl.net>
	 <20051102184705.GD5889@plapn>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nproxy.gmail.com ([64.233.182.199]:26064 "EHLO nproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751204AbVKEE4R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2005 23:56:17 -0500
Received: by nproxy.gmail.com with SMTP id q29so5501nfc
        for <linux-scsi@vger.kernel.org>; Fri, 04 Nov 2005 20:56:16 -0800 (PST)
In-Reply-To: <20051102184705.GD5889@plapn>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Chris Wright <chrisw@osdl.org>, Ashutosh Naik <ashutosh.naik@gmail.com>, support@qlogic.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, stable@kernel.org

Hi,

On 11/3/05, Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:

> Sure.  But, the interface changes present in scsi-misc-2.6, notably:
>
> http://kernel.org/git/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=19a7b4aebf9ad435c69a7e39930338499af4d152
>
> obviate the need for the explicit '#include' -- there are no longer
> any explicit calls to the fc_remote_port_*() functions within
> qla_rscn.c.

Well, hopefully the above code should get merged soon ( in 2.6.15 
hopefully), but until then, I think the current tree should be fixed
with the patch, if the interface changes are not reflected in 2.6.15

Regards
Ashutosh
