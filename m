From: Judith Lebzelter <judith@osdl.org>
Subject: 'scsi-misc' git tree compile errors
Date: Thu, 28 Sep 2006 15:33:39 -0700
Message-ID: <20060928223339.GI26041@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:9698 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932525AbWI1Wdm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Sep 2006 18:33:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@steeleye.com

Hi,

OSDL's automated cross-compile results (PLM) are showing 
a problem with a change in the scsi-misc git tree that got 
checked in this morning.  Here is the error:

include/scsi/scsi_device.h: In function 'scsi_device_reprobe':
include/scsi/scsi_device.h:303: error: void value not ignored as it ought to be

Since this is used in many SCSI drivers, they are not to building.

Thanks,
Judith Lebzelter
OSDL
