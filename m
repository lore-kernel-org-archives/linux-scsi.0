From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Sysfs does not recognise tape devices ?
Date: Fri, 7 Nov 2003 11:21:14 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031107112114.A3302@infradead.org>
References: <Pine.LNX.4.58.0311052318250.2344@kai.makisara.local> <001701c3a426$37fa5110$a0074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:57362 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264081AbTKGLVR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 06:21:17 -0500
Content-Disposition: inline
In-Reply-To: <001701c3a426$37fa5110$a0074d0a@apac.cisco.com>; from surekhap@cisco.com on Thu, Nov 06, 2003 at 10:54:03AM +0530
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>
Cc: 'Kai Makisara' <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

On Thu, Nov 06, 2003 at 10:54:03AM +0530, Surekha.PC wrote:
> 
> Kai,
> 
>  Thanks for the information.
>  The "/sys/bus/scsi/devices/" shows tape device attributes except for
> device name. This is important w.r.t iSCSI devices where we use "udev"
> to create device nodes from sysfs lookup. Can you please let me know how
> soon the feature unfreeze will happen and when this feature can be made
> part of the 2.6 kernel?

Note that the name shows in sysfs really is an internal identifier for the
kernel.  If you want to populate your /dev/iscsi tree using udev calling
mknod with the dev_t from the dev attribute might be a much better choice.

