From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Mon, 5 May 2003 14:45:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505214532.GB3254@beaverton.ibm.com>
References: <20030505083315.GB8416@beaverton.ibm.com> <3EB64F11.2030806@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:50686 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261373AbTEEVbF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 17:31:05 -0400
Content-Disposition: inline
In-Reply-To: <3EB64F11.2030806@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert [dougg@torque.net] wrote:
> What seems to be missing, at least in what I am
> running here is a useful 'name'. There is no 'name'
> file in the listing above (under each 'host<n>'
> directory). There is a 'name' file in that 'device' (symlink)
> directory but it is an empty file here.
> 
> ># tree /sys/bus/scsi/devices
> >/sys/bus/scsi/devices
> >|-- 0:0:0:0 -> ../../../devices/pci0/00:09.0/host0/0:0:0:0
> 
> So finally I can get some output from my
> version of lsscsi (unreleased version 10):
> 
> $ lsscsi -Hl
> [0]    ??
>   cmd_per_lun=64   host_busy=0    sg_tablesize=96   unchecked_isa_dma=0
> [1]    ??
>   cmd_per_lun=64   host_busy=0    sg_tablesize=96   unchecked_isa_dma=0
> [2]    ??
>   cmd_per_lun=3    host_busy=0    sg_tablesize=64   unchecked_isa_dma=0
> [3]    ??
>   cmd_per_lun=5    host_busy=0    sg_tablesize=255  unchecked_isa_dma=0
> 
> Hosts 0 and 1 are the 2 HBAs on a Tekram 390u3w while
> host 2 is a scsi_debug pseudo host and host3 is
> ide-scsi. A name would be instructive.
> 
> $ lsscsi
> [0:0:1:0]    disk    FUJITSU  MAM3184MP        0106  /dev/sda
> [2:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sdb
> [3:0:0:0]    cd      CREATIVE CD5233E          1.00  /dev/sr0
> 

OK, that is a bug. Is proc_name ok for name

# cat /sys/class/scsi_host/*/device/name
ips
aic7xxx
aic7xxx

-andmike
--
Michael Anderson
andmike@us.ibm.com

