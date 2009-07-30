From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Date: Thu, 30 Jul 2009 16:16:29 +0300
Message-ID: <4A719D2D.8070001@panasas.com>
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site> <4A705831.3010002@panasas.com> <20090730093600.GB11381@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:26975
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751492AbZG3NQj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2009 09:16:39 -0400
In-Reply-To: <20090730093600.GB11381@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 07/30/2009 12:36 PM, Michael S. Tsirkin wrote:
> On Wed, Jul 29, 2009 at 05:09:53PM +0300, Boaz Harrosh wrote:
>> []$ ls /usr/include/scsi
>> scsi.h
>> scsi_ioctl.h
>> scsi_tgt_if.h
>> sg.h
> 
> $wget http://ftp.gnu.org/gnu/glibc/glibc-2.10.1.tar.bz2
> $cd glibc-2.10.1
> $find . -name scsi
> ./sysdeps/unix/sysv/linux/scsi
> $ls ./sysdeps/unix/sysv/linux/scsi/
> scsi.h  scsi_ioctl.h  sg.h
> 
> where did you get scsi_tgt_if.h?

You're right I have it from the SCSI target framework (tgt)
(http://stgt.berlios.de/)

It is a Kernel header that should be exported, I'll send a
patch to export it.

Thanks
Boaz
