From: "Smart, James" <James.Smart@Emulex.com>
Subject: HBAAPI
Date: Thu, 8 Apr 2004 09:12:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C01631@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:40141 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261421AbUDHNMQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 09:12:16 -0400
Received: from xbl.ad.emulex.com (xbl.ma.emulex.com [138.239.73.11])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id i38DCECL013891
	for <linux-scsi@vger.kernel.org>; Thu, 8 Apr 2004 06:12:14 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Folks,

We are reviewing ioctls in our driver and would like some input from the
community :)

We have a fair number of ioctls which provide the functionality of HBAAPI.
HBAAPI is a user-level API for interacting with/configuring FC HBAs. There
are similar efforts occuring for iSCSI, etc.

The jist of HBAAPI is that each vendor supplies a "provider" module that
implements the API for the specific hardware. Ours converts into a lot of
ioctls. We see this as a great opportunity to remove the need for a
vendor-specific provider module, and simply have a standard API, supported
by linux FC drivers. There is already a sample application and template
provider over on SourceForge that can be leveraged. We are offering to ante
up a proposal for this API. 

Has there been any thoughts/efforts in doing this in the past ? Any
recommendations for how this should be implemented ?  Any general thoughts?


A couple of additional notes:  

Some of the payload/buffer sizes for the API can exceed 4k in size. Thus,
moving them to sysfs and potentially converting them to multiple operations
is problematic.  Right now, the thought is to leave them as ioctls.  If you
have other ideas, let me know.

HBAAPI provides an interface for setting persistent device mappings. What
are the current thoughts on how driver-level persistent data should be
maintained/saved/etc ?

Thanks

-- James S.


