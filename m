From: Andreas Jellinghaus <aj@leogic.com>
Subject: Re: [PATCH 2.6 ] MPT Fusion driver 3.01.00 update
Date: Tue, 09 Mar 2004 19:13:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <pan.2004.03.09.18.13.44.518204@leogic.com>
References: <0E3FA95632D6D047BA649F95DAB60E57040DA96B@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.224.249]:191 "EHLO main.gmane.org")
	by vger.kernel.org with ESMTP id S262562AbUCJKKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 05:10:07 -0500
Received: from root by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 1B10f8-0000cm-00
	for <linux-scsi@vger.kernel.org>; Wed, 10 Mar 2004 11:10:06 +0100
Received: from 62.245.182.10 ([62.245.182.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 10 Mar 2004 11:10:06 +0100
Received: from aj by 62.245.182.10 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 10 Mar 2004 11:10:06 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi Eric,

we are trying
Fusion MPT base driver 3.00.02
Copyright (c) 1999-2003 LSI Logic Corporation
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator}
Fusion MPT SCSI Host driver 3.00.02
scsi0 : ioc0: LSI53C1030, FwRev=01030a00h, Ports=1, MaxQ=222, IRQ=26
  Vendor: LSILOGIC  Model: 1030 IM       IM  Rev: 1000
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 143376384 512-byte hdwr sectors (73409 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2 sda3 sda4
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
  Vendor: IBM       Model: 25P3495a S320  1  Rev: 1   
  Type:   Processor                          ANSI SCSI revision: 02
Attached scsi generic sg1 at scsi0, channel 0, id 8, lun 0,  type 3

as well as the 3.01.00 version on amd64 dual opteron machines
on mainboards with amd chipset and two ibm 60Gb disks connected.

our problem: terrible speed when writing.
we used dbench for benchmarking under linux 2.6.3
and we get 1-2 mb/s :-(

Any idea how to solve this issue?
Thanks for your help.

Regards, Andreas

