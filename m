From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC] enable FUA support in libata
Date: Fri, 13 Apr 2012 16:11:05 +0800
Message-ID: <20120413081104.GA4953@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Jeff and list,

Recently I met a problem about FUA support of SATA disk.  In my machine,
it has a SATA disk that supports FUA feature.  But after system starts
up, it displays that the disk cannot support FUA from dmesg.

I notice this commit (c3c013a2).  It disables FUA support in all of SATA
disk.  But the commit log is too simple to know why we should disable
FUA support in libata.  Could you please explain it?  Thank you.

Regards,
Zheng
