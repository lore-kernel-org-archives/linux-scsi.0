From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] Fix error handler offline behaviour
Date: Wed, 17 Mar 2004 11:46:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F64E6C2@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:47314 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261532AbUCQQqC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 11:46:02 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

I was concerned about the less `object oriented`
scsi_device_set_state(pDev->pScsi_dev, SDEV_RUNNING) to set the device
online.

Sincerely -- Mark Salyzyn

BTW, good patch, my comments are not disparaging.

-----Original Message-----
From: willy@www.linux.org.uk [mailto:willy@www.linux.org.uk] On Behalf
Of Matthew Wilcox
Sent: Wednesday, March 17, 2004 11:33 AM
To: Salyzyn, Mark
Cc: James Bottomley; SCSI Mailing List
Subject: Re: [PATCH] Fix error handler offline behaviour

On Wed, Mar 17, 2004 at 11:29:04AM -0500, Salyzyn, Mark wrote:
> There was a scsi_device_online(Sdev) handler used in the patch, why
not
> a scsi_device_set_online(Sdev) and a scsi_device_set_offline(Sdev)?

Because then we'd also need a scsi_device_is_online_p(Sdev) ... much
easier just to have a scsi_device_online(Sdev) that can be tested and
assigned to, as appropriate.
