From: Biblioteka UR <biblio@univ.rzeszow.pl>
Subject: Re: mptspi init failure on Sparc SMP in Linux 3.0
Date: Mon, 12 Dec 2011 13:22:12 +0100
Message-ID: <4EE5F1F4.3000006@univ.rzeszow.pl>
References: <4EB7D137.7090903@univ.rzeszow.pl>	 <20111107205409.GG3366@decadent.org.uk> <4EB858E8.6090304@univ.rzeszow.pl> <1320721518.18929.15.camel@deadeye> <A6888A6805518E4EA4AF7072A28264A6047262C728@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atena.univ.rzeszow.pl ([62.93.43.134]:38795 "EHLO
	atena.univ.rzeszow.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab1LLMXF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2011 07:23:05 -0500
In-Reply-To: <A6888A6805518E4EA4AF7072A28264A6047262C728@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, "Moore, Eric" <Eric.Moore@lsi.com>, "647900@bugs.debian.org" <647900@bugs.debian.org>, linux-scsi <linux-scsi@vger.kernel.org>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

Nothing has changed in the topic?
I have the latest linux-image-3.1.0-1-sparc64-smp and the same problem. 
SunFire v490 is running well with linux-image-3.1.0-1-sparc64 (non smp).

Regards,
Mariusz

W dniu 2011-11-10 12:32, Nandigama, Nagalakshmi pisze:
> Can you collect debug level for INIT?
>
> Regards,
> Nagalakshmi
>
>
> -----Original Message-----
> From: Ben Hutchings [mailto:ben@decadent.org.uk]
> Sent: Tuesday, November 08, 2011 8:35 AM
> To: Moore, Eric
> Cc: Biblioteka UR; 647900@bugs.debian.org; linux-scsi; DL-MPT Fusion Linux
> Subject: mptspi init failure on Sparc SMP in Linux 3.0
>
> Mariusz at Biblioteka UR reports this failure in a new Debian installation on a SunFire v490 system:
>
>> [    0.000000] Linux version 3.0.0-1-sparc64-smp (Debian 3.0.0-3) (ben@decadent.org.uk) (gcc version 4.5.3 (Debian 4.5.3-8) ) #1 SMP Sat Aug 27 19:51:14 UTC 20
> [...]
>> [   52.190433] Fusion MPT base driver 3.04.19
>> [   52.238528] Copyright (c) 1999-2008 LSI Corporation
> [...]
>> [   52.370161] Fusion MPT SPI Host driver 3.04.19
>> [   52.370364] mptbase: ioc0: Initiating bringup
> [...]
>> [   52.847504] ioc0: LSI53C1030 C0: Capabilities={Initiator,Target}
> [...]
>> [   68.319518] mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!, doorbell=0x24000000
>> [   69.175505] mptbase: ioc0: Attempting Retry Config request type 0x3, page 0x, action 0
>> [   84.267524] mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!, doorbell=0x24000000
>> [   84.364482] mptbase: ioc0: Initiating recovery
>> [   90.299505] mptbase: ioc0: Attempting Retry Config request type 0x3, page 0x, action 0
>> [  105.391523] mptbase: ioc0: WARNING - Issuing Reset from
>> mpt_config!!, doorbell=0x24000000 [  105.488509] mptbase: ioc0:
>> Initiating recovery [  126.527516] mptbase: ioc0: WARNING - Issuing
>> Reset from mpt_config!!, doorbell=0x24000000 [  127.383505] mptbase:
>> ioc0: Attempting Retry Config request type 0x4, page 0x1, action 0 [
>> 142.475528] mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!,
>> doorbell=0x24000000 [  142.572504] mptbase: ioc0: Initiating recovery
>> [  148.611505] mptbase: ioc0: Attempting Retry Config request type
>> 0x4, page 0x1, action 0 [  163.703482] mptbase: ioc0: WARNING -
>> Issuing Reset from mpt_config!!, doorbell=0x24000000 [  163.800495]
>> mptbase: ioc0: Initiating recovery
> (I think there are some characters missing in the above log, particularly the page numbers.)
>
> However, the driver apparently works on the same system in a !SMP kernel configuration.
>
> The complete report can be found at<http://bugs.debian.org/647900>.
> Can you suggest any way to correct or debug this problem?
>
> Ben.
>
> --
> Ben Hutchings
> You can't have everything.  Where would you put it?
>

