From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
Date: Mon, 28 Mar 2005 07:33:25 -0300
Message-ID: <20050328103324.GB28175@logos.cnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([209.128.68.125]:42670 "EHLO hera.kernel.org")
	by vger.kernel.org with ESMTP id S261876AbVC1PYI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 10:24:08 -0500
Received: from logos.cnet (localhost [127.0.0.1])
	by hera.kernel.org (8.12.11/8.12.8) with ESMTP id j2SFO6s0022053
	for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2005 07:24:06 -0800
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi SCSI gurus,

You probably already know about this, but just in case:

v2.6.12-rc1 yields

program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO

On my Fusion MPT based machine, on bootup.

[marcelo@xeon linux-216]$ dmesg | grep Fus
Fusion MPT base driver 3.01.19
Fusion MPT SCSI Host driver 3.01.19

