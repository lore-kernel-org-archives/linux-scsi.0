From: Tom Rini <trini@ti.com>
Subject: Re: Commit a692b0e broke my mvsas card
Date: Tue, 17 Apr 2012 07:44:06 -0700
Message-ID: <4F8D81B6.3080604@ti.com>
References: <20120416224250.GA1983@bill-the-cat>		 <CABE8wwvbSsc02U_m+20-DQgsZ2gQCi_A6susCrmfyx_scQkccw@mail.gmail.com>		 <4F8CAC6F.6070907@ti.com>	 <1334620782.23541.2.camel@ultramagnus.opencreations.com>	 <4F8CCD0C.5060900@ti.com> <1334633159.13899.4.camel@dwillia2-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:57170 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab2DQOo4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Apr 2012 10:44:56 -0400
In-Reply-To: <1334633159.13899.4.camel@dwillia2-mobl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <JBottomley@parallels.com>, Xiangliang Yu <yuxiangl@marvell.com>

On 04/16/2012 08:25 PM, Dan Williams wrote:
> On Mon, 2012-04-16 at 18:53 -0700, Tom Rini wrote:
>>> Thanks, yes it looks like a new regression.  Can you tell me if the
>>> following fixes it?
>>
>> No joy, oopses.  http://alnk.org/43youngkirby for the dmesg and oops.
>>
>
> Agh, sorry, I rushed that one.  The phy array is initialized later, here
> is another run at it:

No crash, but 2 out of 4 SSDs still: http://pastebin.com/PCUGTBqG

-- 
Tom
