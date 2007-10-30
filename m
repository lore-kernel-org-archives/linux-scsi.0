From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 1/8] scsi: megaraid_sas - add hibernation support
Date: Tue, 30 Oct 2007 12:18:12 -0500
Message-ID: <1193764692.3321.88.camel@localhost.localdomain>
References: <1191253256.5850.4.camel@dhcp-75-534.se.lsil.com>
	 <9738BCBE884FDB42801FAD8A7769C265010A0A09@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:44475 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752419AbXJ3RSO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 13:18:14 -0400
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C265010A0A09@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>

On Mon, 2007-10-29 at 14:26 -0600, Yang, Bo wrote:
> James,
>  
> We submitted the "03.16-rc1" (megaraid_sas) patches about three weeks
> back.  Do you have any feedback or we need to re-submit the patches?

Randy Dunlap asked you why the module parameters were invisible ... is
there a reason (if not the patch needs to be updated to make them
visible and writeable by root).

James



