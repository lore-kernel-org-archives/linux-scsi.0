From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] REPORT LUN scan even if no storage is available on LUN 0
Date: Thu, 13 Jan 2005 16:21:34 -0800
Message-ID: <20050114002134.GA14102@us.ibm.com>
References: <20041210123333.GD685@bogon.ms20.nix> <20041213222206.GA18893@us.ibm.com> <20050110164200.GA8655@bogon.ms20.nix> <20050111181500.GA9046@us.ibm.com> <20050113124032.GB5701@bogon.ms20.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:11159 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261727AbVANAWH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jan 2005 19:22:07 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j0E0M7BW021954
	for <linux-scsi@vger.kernel.org>; Thu, 13 Jan 2005 19:22:07 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0E0M7Zc245478
	for <linux-scsi@vger.kernel.org>; Thu, 13 Jan 2005 19:22:07 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j0E0M6nk028226
	for <linux-scsi@vger.kernel.org>; Thu, 13 Jan 2005 19:22:07 -0500
Content-Disposition: inline
In-Reply-To: <20050113124032.GB5701@bogon.ms20.nix>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guido Guenther <agx@sigxcpu.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Jan 13, 2005 at 01:40:32PM +0100, Guido Guenther wrote:

> No. Without any patches we had all the available devices in
> /proc/scsi/scsi but none was marked as "claimed by the OS" (all were
> marked with a star, but could then be "added" via "scsi
> add-single-device ... > /proc/scsi/scsi"). 

Oh ...  the "*" is used in the /proc/scsi/qla2xxx/N files, not
/proc/scsi/scsi.

Is /proc/scsi/qla2xxx/N not showing any LUNs?

If so, that is a different problem.

-- Patrick Mansfield
