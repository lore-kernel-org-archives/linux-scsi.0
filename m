From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [ PATCH 0/3 ] mpt fusion enhancements
Date: Fri, 22 Jun 2012 11:30:43 +0200
Message-ID: <4FE43B43.6030405@fastmail.fm>
References: <200902061408.46652.bs@q-leap.de> <loom.20120621T230838-721@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:41021 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761856Ab2FVJar (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2012 05:30:47 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id q5M9UiVT031032
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jun 2012 11:30:44 +0200
In-Reply-To: <loom.20120621T230838-721@post.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ron Eisler <Ron.Eisler@ca.weatherford.com>
Cc: linux-scsi@vger.kernel.org

Hello Ron,

On 06/21/2012 11:20 PM, Ron Eisler wrote:
> Bernd Schubert <bs <at> q-leap.de> writes:
>
>>
>> Here are 3 patches for the mpt fusion driver.
>>
>
> Hello Bernd,
>
> I am looking mpt fusion backport fixes for the LSI 53C1030 that will run with
> Linux kernel 2.6.27.62. Current version is 3.04.07. Our problem is that running
> on VMWare VSphere, with the SAN heavily loaded, we get SCSI timeouts.
>
> Ex. mptscsih: ioc0: attempting task abort! (sc-ffff...)
>      sd 0:0:0:0: [sda] CDB: Read (10): 28 00 ...
>      mptscsih: ioc0: task abort: Success (sc=ffff...)
>
> The system hangs for 30 seconds on each one.
>
> I see comments/patches here: http://comments.gmane.org/gmane.linux.scsi/48215
>
> Do you have source that would work for 2.6.27.62?
>

is there a chance you could use the the mpt-4.x driver? The other simple 
way would be to use the driver from the SLES10 kernel (SLES10 without 
any service pack, so 2.6.27).
I think you could simply replace the drivers/message/funsion directory.

I definitely cannot recommend to use a more recent kernel, as I know 
from Q-Leap that recent kernels run into DV (domain validation) races, 
which they 'solved' by introducing simple sleeps into the code.
I'm still in contact with Q-Leap, but decided to take another job some 
time ago....


Cheers,
Bernd
