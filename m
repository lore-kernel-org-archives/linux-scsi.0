From: vikas.chaudhary@qlogic.com
Subject: [RFC-V2 PATCH 0/5] Proposal for iSCSI Network Configuration
Date: Sat,  2 Apr 2011 11:34:16 -0700
Message-ID: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39496 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756373Ab1DBSjK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Apr 2011 14:39:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

These are RFC-V2 follow-up patches to configuring network setting for
iSCSI adapter (qla4xxx) that use private IP address. Please review
proposal/implementation and let us know the feedback.
Our Initial RFC patches is here:
http://marc.info/?l=linux-scsi&m=129863193520309&w=2
http://groups.google.com/group/open-iscsi/browse_thread/thread/2924e8d871233436

New patches include following changes:
 - Take care of comments from Mike Christie about using multiple IO Vector mechanism
   to send netconfig parameters from application space to kernel.
 - Added support to display IPV6 address and Linklocal address auto_config type in sysfs.

Kernel patches:

Lalit Chandivade (2):
      iscsi_transport: add set_net_config
      qla4xxx: add support for set_net_config

Vikas Chaudhary (3):
      qla4xxx: Added new "struct ipaddress_config"
      iscsi_transport: show network configuration in sysfs
      qla4xxx: added support to show multiple iface in sysfs

Application side iscsiadm patch:

Lalit Chandivade (1):
      iscsiadm: Add netconfig support in iscsiadm and iscsid

Thanks,
Vikas.
