From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [2.6 patch] let AIC7{9,X}XX_BUILD_FIRMWARE depend on!PREVENT_FIRMWARE_BUILD
Date: Tue, 03 Aug 2004 13:49:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <410FD035.6080905@adaptec.com>
References: <20040801185543.GB2746@fs.tum.de> <20040801191118.GA7402@mars.ravnborg.org> <410FA577.4040602@adaptec.com> <410FBDAA.4070907@optonline.net> <1091550985.2816.10.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:4829 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S266768AbUHCRtz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2004 13:49:55 -0400
In-Reply-To: <1091550985.2816.10.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: Nathan Bryant <nbryant@optonline.net>, Sam Ravnborg <sam@ravnborg.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Adrian Bunk <bunk@fs.tum.de>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 2004-08-03 at 18:30, Nathan Bryant wrote:
> 
>>Luben Tuikov wrote:
>>
>>>Hi Sam,
>>>
>>>You can forward it to Linus and I'll also integrate it
>>>to the latest version of the drivers, yet to be integrated
>>>to the mainline kernel.
>>
>>Luben -
>>
>>Are the latest drivers going to be available in BitKeeper format before 
>>they get merged?
> 
> 
> I'm sure they'll be submitted in small incremental updates which can be
> submitted and merged in smaller pieces to keep testability to a
> maximum.... 

Yes, no problem.  Whatever you guys want.
I can provide small incremental patches (right out of
perforce), and generate incremantal BKs (will have to look into
that).

-- 
Luben


