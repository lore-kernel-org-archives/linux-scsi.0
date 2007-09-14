From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Fri, 14 Sep 2007 16:54:07 +0200
Message-ID: <46EAA08F.30703@s5r6.in-berlin.de>
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <1189371621.3526.28.camel@localhost.localdomain> <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org> <20070912224655.GC3563@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:39467 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXINOzU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Sep 2007 10:55:20 -0400
In-Reply-To: <20070912224655.GC3563@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@SteelEye.com>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Adrian Bunk wrote:
> On Sun, Sep 09, 2007 at 05:11:44PM -0400, Jeff Garzik wrote:
>> Let's step back a moment and consider the actual scale and impact of the 
>> problem at hand.
>>
>> The vast majority of users are consumers of pre-compiled kernels, built by 
>> People With Clue(tm), who figured this stuff out as soon as it was 
>> introduced.
[...]
> In my experience, the vast majority of kconfig users are not the few 
> people working on distribution kernels, most of the kconfig userbase 
> could be better described by the use case "sysadmin who knows about the 
> hardware in his machine and which filesystems he uses".

The patch which is discussed here is specifically targeted towards users
who are convinced that they can migrate to different drivers without
reading Kconfig help texts.
-- 
Stefan Richter
-=====-=-=== =--= -===-
http://arcgraph.de/sr/
