From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/6]  qla2xxx: sysfs attribute additions...
Date: Tue, 31 Jan 2006 16:01:47 -0800
Message-ID: <20060201000146.GA4456@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:34998 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S932191AbWBAABx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 19:01:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Here's a set of patches which:

* provide final fc_transport related attribute information
* export some vendor specific information via sysfs attributes:
  - beacon
  - option rom

Thanks,
Andrew Vasquez
