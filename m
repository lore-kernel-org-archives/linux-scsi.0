From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH] iscsi: add module alias
Date: Thu, 9 Dec 2010 09:37:56 -0800
Message-ID: <20101209093756.06210c6a@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:46909 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab0LIRh6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2010 12:37:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

Since iscsi transport can be built as a module and uses netlink socket
to communicate. The module should have an alias to autoload when socket
of NETLINK_ISCSI type is requested.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/drivers/scsi/scsi_transport_iscsi.c	2010-12-09 09:21:42.784962783 -0800
+++ b/drivers/scsi/scsi_transport_iscsi.c	2010-12-09 09:22:40.812352712 -0800
@@ -2200,3 +2200,4 @@ MODULE_AUTHOR("Mike Christie <michaelc@c
 MODULE_DESCRIPTION("iSCSI Transport Interface");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(ISCSI_TRANSPORT_VERSION);
+MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_ISCSI);

