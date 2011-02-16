From: michaelc@cs.wisc.edu
Subject: iSCSI update for scsi-misc/2.6.39
Date: Wed, 16 Feb 2011 15:04:24 -0600
Message-ID: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab1BPVEb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:31 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4Uf9003192
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:30 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tsn004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following patches were made for scsi misc/2.6.39.
The first 7 patches include the bnx2i update that
was submitted here
http://marc.info/?l=linux-scsi&m=129426012515027&w=2
minus the patch that was adding a driver specific
interface to set a tcp/ip setting.

The last patches enable TEXT PDU support in cxgbi, fix
a endpoint leak during iscsi boot, and fix reading
of the connection/ep ip address and port.

[PATCH 01/17] BNX2I: Allow ep CONNECT_FAILED condition to go through proper cleanup
[PATCH 02/17] BNX2I: Fixed the 32-bit swapping of the LUN field for nopouts for 5771X
[PATCH 03/17] BNX2I: Added handling for unsupported iSCSI offload hba
[PATCH 04/17] BNX2I: Added support for the 57712(E) devices
[PATCH 05/17] BNX2I: Added jumbo MTU support for the no shost case
[PATCH 06/17] BNX2I: Added iSCSI text pdu support for iSCSI offload
[PATCH 07/17] BNX2I: Updated to version 2.6.2.3
[PATCH 08/17] cxgbi: enable TEXT PDU support
[PATCH 09/17] iscsi: fix iscsi_endpoint leak
[PATCH 10/17] iscsi class: remove unused active variable
[PATCH 11/17] libiscsi: add helper to convert addr to string
[PATCH 12/17] iscsi_tcp: use iscsi_conn_get_addr_param libiscsi function
[PATCH 13/17] iscsi class: add callout to get iscsi_endpoint values
[PATCH 14/17] cxgbi: convert to use iscsi_conn_get_addr_param
[PATCH 15/17] bnx2i: fix null ptr ref in conn get param
[PATCH 16/17] iser: export addr and port
[PATCH 17/17] be2iscsi: fix null ptr ref in conn get param
