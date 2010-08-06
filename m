From: michaelc@cs.wisc.edu
Subject: FC: fix rport dev_loss_tmo initialization
Date: Fri,  6 Aug 2010 03:02:36 -0500
Message-ID: <1281081761-24586-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760545Ab0HFH6q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2010 03:58:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jeykholt@cisco.com, andrew.vasquez@qlogic.com, giridhar.malavali@qlogic.com, James.Smart@Emulex.Com, brking@us.ibm.com

This patchset fixes a bug where the rport dev_loss_tmo
is reset when devices are added, because the driver
sets the dev_loss_tmo in the scsi_host_template slave_configure
function. 

The patches were made over scsi-misc. I have tested lpfc and
qla2xxx, and I have compile tested ibmvfc and fnic.


[PATCH 1/5] fc class: add fc host default default dev loss setting
[PATCH 2/5] qla2xxx: do not reset dev_loss_tmo in slave callout
[PATCH 3/5] lpfc: do not reset dev_loss_tmo in slave callout
[PATCH 4/5] fnic: do not reset dev_loss_tmo in slave callout
[PATCH 5/5] ibmvfc: do not reset dev_loss_tmo in slave callout
