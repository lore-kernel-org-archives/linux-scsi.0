From: vikas.chaudhary@qlogic.com
Subject: [PATCH 0/5] qla4xxx: Proposal for iSCSI Network Configuration
Date: Fri, 22 Apr 2011 11:07:41 -0700
Message-ID: <1303495666-731-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46845 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755177Ab1DVSNU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2011 14:13:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

These patches are to configure network setting for iSCSI Adapter (qla4xxx)
that use private IP address. Patches are made on top of scsi-misc-2.6
git tree.

This patchset is revision of our RFC-v2 patchset which we posted earlier:
link: http://marc.info/?l=linux-scsi&m=130176955503554&w=2

Patches include following major changes from RFC-v2 patches.

- Cleanup white space errors.
- rename sysfs attr file from state to enabled as suggested by Mike Christie

Kernel Patches:
Lalit Chandivade (2):
      iscsi_transport: add support for set_net_config
      qla4xxx: add support for set_net_config

Vikas Chaudhary (3):
      qla4xxx: Added new "struct ipaddress_config"
      iscsi_transport: show network configuration in sysfs
      qla4xxx: added support to show multiple iface in sysfs

iscsiadm patch:
Lalit Chandivade (1):
      iscsiadm: Add netconfig support in iscsiadm and iscsid

Thanks,
Vikas.
