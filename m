From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 0/5] lpfc 8.1.10 :  8.1.10 patches for new FC functionality
Date: Fri, 18 Aug 2006 17:46:29 -0400
Message-ID: <1155937589.12933.26.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:32454 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751492AbWHRVq0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 17:46:26 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k7ILkP0G024252
	for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2006 14:46:25 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch updates the lpfc driver to revision 8.1.10. The patches add
support for several of the new fc transport attributes and callback
additions.

Changes include:
- Add support to post events via new FC event interfaces
- Add support to return adapter symbolic name (now that attribute is dynamic)
- Add support for new dev_loss_tmo callback 
- Add support for the new fast_io_fail callback
- Add support for a new lpfc soft_wwpn sysfs attribute
- Change version number to 8.1.10


These patches are intended for scsi-misc-fixes-2.6.

The patches are dependent on the following lpfc and fc transport patches:
 lpfc:
   http://marc.theaimsgroup.com/?l=linux-scsi&m=115443207423970&w=2  (8.1.8)
   http://marc.theaimsgroup.com/?l=linux-scsi&m=115583213412718&w=2  (8.1.9)
 fc transport:
   http://marc.theaimsgroup.com/?l=linux-scsi&m=115555807316329&w=2  (fc_symbolic_name)
   http://marc.theaimsgroup.com/?l=linux-scsi&m=115581614930261&w=2  (fc_system_hostname)
   http://marc.theaimsgroup.com/?l=linux-scsi&m=115593664816371&w=2  (netlink events)
   http://marc.theaimsgroup.com/?l=linux-scsi&m=115593687604517&w=2  (dev_loss_tmo callbk)

-- james s



