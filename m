From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] dpt_i2o: convert to SCSI hotplug model
Date: Tue, 31 Jul 2007 08:47:50 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01CB7368@otce2k301.adaptec.com>
References: <20070730211917.GK21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:43088 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbXGaMr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 08:47:58 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070730211917.GK21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

ACK!

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Matthew Wilcox [mailto:matthew@wil.cx] 
> Sent: Monday, July 30, 2007 5:19 PM
> To: AACRAID; linux-scsi@vger.kernel.org
> Subject: [PATCH] dpt_i2o: convert to SCSI hotplug model
>  
> dpt_i2o: Convert to new SCSI driver model
> 
>  - Delete refereces to HOSTS_C
>  - Switch to module_init/module_exit instead of detect/release
>  - Don't pass around the host template and rename it to adpt_template
>  - Switch from scsi_register/scsi_unregister to scsi_host_alloc,
>    scsi_add_host, scsi_scan_host and scsi_host_put.
