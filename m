From: "Surekha.PC" <surekhap@cisco.com>
Subject: RE: iSCSI device naming issues
Date: Wed, 7 Jul 2004 14:35:13 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAAjzu5VqiH1EizmlIkf87BNwEAAAAA@cisco.com>
References: <1088971063.2736.10.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ind-iport-1-sec.cisco.com ([64.104.129.9]:7313 "EHLO
	ind-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S265002AbUGGJFV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jul 2004 05:05:21 -0400
In-Reply-To: <1088971063.2736.10.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

> On Thu, 2004-07-01 at 15:58, Surekha.PC wrote:
> > Whenever an iSCSI device is configured in the system, a 
> hotplug event 
> > is generated which invokes udev for device node creation. 
> iSCSI driver 
> > has a CALLOUT rule for udev to generate a unique name for iSCSI 
> > devices.
> 
> wouldn't this all be a lot cleaner if you follow the 
> one-hba-per-remote-host model ?
> 

Are you referring to one hba per Discovery IP?

Even if I have single or multiple HBA, the current scheme of
things is not going to solve iSCSI device naming problem. I
have to anyway lookup sysfs path to identify iSCSI devices.

-Surekha

