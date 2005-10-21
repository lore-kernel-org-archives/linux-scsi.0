From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: Recover SCSI disks
Date: Fri, 21 Oct 2005 13:43:28 +0100
Message-ID: <djanpg$h11$1@sea.gmane.org>
References: <dj8a8v$ta0$1@sea.gmane.org> <4358404B.9080006@torque.net> <4358D336.7040303@robinbowes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:25498 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S964927AbVJUMpu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 08:45:50 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1ESwHG-0003Xa-56
	for linux-scsi@vger.kernel.org; Fri, 21 Oct 2005 14:45:42 +0200
Received: from 83-216-145-213.pambow882.adsl.metronet.co.uk ([83.216.145.213])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2005 14:45:42 +0200
Received: from robin-lists by 83-216-145-213.pambow882.adsl.metronet.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2005 14:45:42 +0200
In-Reply-To: <4358D336.7040303@robinbowes.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Robin Bowes said the following on 21/10/2005 12:38:
> Douglas Gilbert said the following on 21/10/2005 02:11:
> 
>> Robin,
>> You may like to fetch sg3_utils and try sg_format thus:
>>    sg_format /dev/sda
>> assuming a disk you have fetched from the array is placed
>> at /dev/sda .
> 
> 
> Hmm, sg3_utils doesn't seem to contain sg_format:
> 
> [root@compact ~]# rpm -ql sg3_utils
> /usr/bin/scsi_devfs_scan
> /usr/bin/sg_dd
> /usr/bin/sg_inq
> /usr/bin/sg_logs
> /usr/bin/sg_map
> /usr/bin/sg_modes
> /usr/bin/sg_rbuf
> /usr/bin/sg_read
> /usr/bin/sg_readcap
> /usr/bin/sg_reset
> /usr/bin/sg_scan
> /usr/bin/sg_senddiag
> /usr/bin/sg_start
> /usr/bin/sg_test_rwbuf
> /usr/bin/sg_turs
> /usr/bin/sginfo
> /usr/bin/sgm_dd
> /usr/bin/sgp_dd
> (man pages snipped)

Let me re-phrase that, the Fedora Core 4 sg3_utils-1.06-5 rpm doesn't 
contain sg_format (the above listing is from there).

I see from rpmfind that it is in the mandrake sg3_utils-1.16-1mdk rpm.

Ah, I've got the latest version from http://sg.torque.net/sg/index.html

R.
-- 
http://robinbowes.com

If a man speaks in a forest,
and his wife's not there,
is he still wrong?

