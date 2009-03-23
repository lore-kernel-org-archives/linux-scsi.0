From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: kernel panics and errors on lsi 1064e
Date: Mon, 23 Mar 2009 14:25:23 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1410DBBE2D@inbmail01.lsi.com>
References: <Pine.LNX.4.64.0903201242300.27079@tassadar.physics.auth.gr>
 <1237562844.12008.55.camel@localhost.localdomain>
 <Pine.LNX.4.64.0903202204490.1954@tassadar.physics.auth.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og115.obsmtp.com ([64.18.2.217]:47425 "EHLO
	exprod7og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbZCWIzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Mar 2009 04:55:41 -0400
In-Reply-To: <Pine.LNX.4.64.0903202204490.1954@tassadar.physics.auth.gr>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dimitris Zilaskos <dzila@tassadar.physics.auth.gr>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "Mohapatra, Sisir" <Sisir.Mohapatra@lsi.com>

Hi,

After firmware upgrade, you are seeing only MPT logs but system is running fine. Those prints are not harmful, but it requires attention why it happened? I need some information to help you further.

1. Information of driver version. (cat /proc/mpt/version)
2. Information of firmware. (cat /proc/mpt/iocX/info)
3. Driver log level setting. 
       MPT driver has debug_level settings to get more logs.
       Check "cat /sys/class/scsi_host/host*/proc_name"
       Use index number for "mptsas" from result of previous command.
       "echo 0x8188 > /sys/class/scsi_host/host<index>/debug_level".

 
NOTE: Above debug level settings are available from some version onwards. 
       Driver used by you may not have this support, depending upon driver	version.

Please provide us log with driver debug enable as mention in #3 will help to debug further.

Added Sisir and Sathya in CC list.

Thanks
Kashyap



-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Dimitris Zilaskos
Sent: Saturday, March 21, 2009 1:41 AM
To: James Bottomley
Cc: linux-scsi@vger.kernel.org; Moore, Eric
Subject: Re: kernel panics and errors on lsi 1064e


Thank you for you reply,

> So that's the right thing to do (or better yet, contact LSI support to
> see if they have a newer version).

Will do so

> This has become a log information, so the IOC firmware now dealt with
> whatever the problem was.
>
>
>> Is something broken here? I am close to ask for the systems to be replaced.
>
> You imply that with the firmware upgrade, nothing now goes wrong, so
> everything sounds to be OK.


Well it has been only 3 days, and these strange messages keep showing up, 
so I am still worried because it will be harder to get them replaced later 
and at the same time have the users complaining. But it looks like my 
options are limited.




-- 
=============================================================================
Dimitris Zilaskos
GridAUTH Operations Centre @ Aristotle University of Thessaloniki , Greece
Tel: +302310998988 Fax: +302310994309
http://www.grid.auth.gr 
=============================================================================
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Internal Virus Database is out of date.
Checked by AVG - www.avg.com 
Version: 8.0.237 / Virus Database: 270.11.10/1995 - Release Date: 03/11/09 08:28:00
