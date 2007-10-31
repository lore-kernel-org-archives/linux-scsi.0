From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 1/8] scsi: megaraid_sas - add hibernation support
Date: Wed, 31 Oct 2007 12:12:24 -0500
Message-ID: <1193850744.3411.69.camel@localhost.localdomain>
References: <1191253256.5850.4.camel@dhcp-75-534.se.lsil.com>
	 <9738BCBE884FDB42801FAD8A7769C265010A0A09@NAMAIL1.ad.lsil.com>
	 <1193764692.3321.88.camel@localhost.localdomain>
	 <9738BCBE884FDB42801FAD8A7769C265010A0A11@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45130 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756881AbXJaRMa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 13:12:30 -0400
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C265010A0A11@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>, "Kolli, Neela" <Neela.Kolli@lsi.com>

On Wed, 2007-10-31 at 07:25 -0600, Yang, Bo wrote:
> James,
> I did respond to Randy earlier. 

Sorry, I couldn't find it in the archive when I looked ... although the
scsi reflector seems to be missing quite a few of your emails for some
reason.

> About the module params being added : 
> 
> The fast_load parameter is for the user to decide at driver load time
> if (s)he wants to skip scan of devices in PD channels. 
> 
> After driver is loaded the user cannot be permitted to modify this
> value. If the user needs to see the devices in the PD channels, (s)he
> may initiate a scan via sysfs/proc based on the kernel being used.
> Once the user has done the scan, the fast_load value does not have any
> significance and thus not exposed for reading.
> 
> cmd_per_lun & max_sectors are also intended to be provided by user
> only at driver load time. In the current implementation both these do
> appear as read-only values under host# in sysfs. The current design is
> not to allow these values to be modified on the fly. 

fastload sounds reasonable.  cmd_per_lun and max_sectors could
reasonably be altered at runtime ... just execute and unbind and rebind
operation to make them take effect.

James



