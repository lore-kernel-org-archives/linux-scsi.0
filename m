From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Date: Thu, 30 Jul 2009 12:36:01 +0300
Message-ID: <20090730093600.GB11381@redhat.com>
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site> <4A705831.3010002@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46455 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZG3JhK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2009 05:37:10 -0400
Content-Disposition: inline
In-Reply-To: <4A705831.3010002@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 05:09:53PM +0300, Boaz Harrosh wrote:
> []$ ls /usr/include/scsi
> scsi.h
> scsi_ioctl.h
> scsi_tgt_if.h
> sg.h

$wget http://ftp.gnu.org/gnu/glibc/glibc-2.10.1.tar.bz2
$cd glibc-2.10.1
$find . -name scsi
./sysdeps/unix/sysv/linux/scsi
$ls ./sysdeps/unix/sysv/linux/scsi/
scsi.h  scsi_ioctl.h  sg.h

where did you get scsi_tgt_if.h?
