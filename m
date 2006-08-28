From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] aic94xx: fix hotplug/unplug for expanderless systems
Date: Mon, 28 Aug 2006 16:06:32 -0700
Message-ID: <44F376F8.9090804@us.ibm.com>
References: <1156803771.7420.23.camel@localhost.localdomain>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:63369 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751569AbWH1XGe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 19:06:34 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k7SN6XRN026294
	for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2006 19:06:34 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7SN6X2c297508
	for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2006 19:06:33 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7SN6Xad001626
	for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2006 19:06:33 -0400
In-Reply-To: <1156803771.7420.23.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Works quite nicely with my SATA/SAS disks/machines too.

--D

Acked-by: Darrick J. Wong <djwong@us.ibm.com>

Alexis Bruemmer wrote:
> This patch fixes hotplug/unplug for expanderless systems by not queuing
> an event just to do sas_unregister_domain_devices.
> 
> -Alexis
