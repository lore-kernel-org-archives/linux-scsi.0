From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: Recover SCSI disks
Date: Fri, 21 Oct 2005 12:38:30 +0100
Message-ID: <4358D336.7040303@robinbowes.com>
References: <dj8a8v$ta0$1@sea.gmane.org> <4358404B.9080006@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.metronet.co.uk ([213.162.97.75]:7636 "EHLO
	mail.metronet.co.uk") by vger.kernel.org with ESMTP id S964905AbVJULib
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 07:38:31 -0400
In-Reply-To: <4358404B.9080006@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert said the following on 21/10/2005 02:11:
> Robin,
> You may like to fetch sg3_utils and try sg_format thus:
>    sg_format /dev/sda
> assuming a disk you have fetched from the array is placed
> at /dev/sda .

Hmm, sg3_utils doesn't seem to contain sg_format:

[root@compact ~]# rpm -ql sg3_utils
/usr/bin/scsi_devfs_scan
/usr/bin/sg_dd
/usr/bin/sg_inq
/usr/bin/sg_logs
/usr/bin/sg_map
/usr/bin/sg_modes
/usr/bin/sg_rbuf
/usr/bin/sg_read
/usr/bin/sg_readcap
/usr/bin/sg_reset
/usr/bin/sg_scan
/usr/bin/sg_senddiag
/usr/bin/sg_start
/usr/bin/sg_test_rwbuf
/usr/bin/sg_turs
/usr/bin/sginfo
/usr/bin/sgm_dd
/usr/bin/sgp_dd
(man pages snipped)

Any idea where to find it?

R.
-- 
http://robinbowes.com

If a man speaks in a forest,
and his wife's not there,
is he still wrong?
