From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: Sysfs does not recognise tape devices ?
Date: Wed, 5 Nov 2003 23:25:38 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0311052318250.2344@kai.makisara.local>
References: <018f01c3a397$e093d600$a0074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep20-0.kolumbus.fi ([193.229.0.47]:24038 "EHLO
	fep20-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S263229AbTKEVZk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Nov 2003 16:25:40 -0500
In-Reply-To: <018f01c3a397$e093d600$a0074d0a@apac.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 5 Nov 2003, Surekha.PC wrote:

>
> Hi,
>
> I have a iSCSI setup with scsi disk and tape configured as iSCSI
> targets. The disks are recognised with sysfs, but tape device entries
> are not getting created.
>
The tapes should be visible as SCSI devices in, e.g.,
/sys/bus/scsi/devices/. You can find disks in /sys/block. The tapes belong
to /sys/cdev but it is a very new addition to sysfs and the code to show
the tapes there has not been done yet. It should be very easy based on
Doug Gilberts code for sg but the feature freeze will prevent adding it
to the official kernel for some time.

-- 
Kai
