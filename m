From: jsemon@gcinfotech.com
Subject: (unknown)
Date: Mon, 17 Dec 2007 17:35:00 -0500 (EST)
Message-ID: <1271.10.1.0.54.1197930900.squirrel@mail.gcit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server02.globalcareers.com ([216.254.106.114]:35244 "EHLO
	server02.globalcareers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356AbXLQW4L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2007 17:56:11 -0500
Subject: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsil.com, support@lsil.com, mpt_linux_developer@lsil.com, linux-scsi@vger.kernel.org

To whom it may concern,

My name is Jason and  I am with a company called GC InfoTech, I am
working with a server that has the integrated LSI MegaRaid 1068e
(M1068e.01.08221427R).

I am trying to build a module using the vanilla kernel, from your
source drivers, that we will be able to use with Gentoo Linux. I am
currently not having any luck, as the compile breaks every time.

I have tried the precompiled driver for RHEL with CentOS and was
unsuccessful getting it to work as well.

#make modules
CHK     include/linux/version.h
CHK     include/linux/utsrelease.h
CALL    scripts/checksyscalls.sh
CC [M]  drivers/message/fusion/mptsas.o
drivers/message/fusion/mptsas.c: In function `mptsas_hotplug_work':
drivers/message/fusion/mptsas.c:3605: warning: passing arg 1 of
`schedule_delayed_work' from incompatible pointer type
drivers/message/fusion/mptsas.c:3651: warning: passing arg 1 of
`schedule_delayed_work' from incompatible pointer type
drivers/message/fusion/mptsas.c: In function
`mptsas_broadcast_primative_work':
drivers/message/fusion/mptsas.c:4141: error: structure has no member
named `work'
drivers/message/fusion/mptsas.c:4141: warning: type defaults to `int'
in declaration of `__mptr'
drivers/message/fusion/mptsas.c:4141: warning: initialization from
incompatible pointer type
drivers/message/fusion/mptsas.c:4141: error: structure has no member
named `work'
drivers/message/fusion/mptsas.c: In function `mptsas_reprobe_lun':
drivers/message/fusion/mptsas.c:3289: warning: ignoring return value of
`scsi_device_reprobe', declared with attribute warn_unused_result
make[3]: *** [drivers/message/fusion/mptsas.o] Error 1
make[2]: *** [drivers/message/fusion] Error 2
make[1]: *** [drivers/message] Error 2
make: *** [drivers] Error 2


#




I am assuming that the sources I am using are for RHLE or SLES only. Is
this assumption correct? Is there any way that I can get this working?




I have invested a great deal of money into these servers and it would
be great to be able to use them with Gentoo.



Do you have any ideas, maybe an unreleased driver? Any help is greatly
appreciated and if there is anything else you need to know, please let
me know and I will get whatever you need.




Thanks,


-- 
Jason Semon
GC InfoTech
Work: (203) 327-5700
Cell: (203) 964-7356

