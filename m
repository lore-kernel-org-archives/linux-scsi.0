From: Andy Grover <agrover@redhat.com>
Subject: [ANNOUNCE] targetd 0.1
Date: Wed, 13 Jun 2012 12:28:06 -0700
Message-ID: <4FD8E9C6.2020600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab2FMT2T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2012 15:28:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>, libstoragemgmt-devel@lists.sourceforge.net

targetd allows the remote configuration of a storage appliance,
implemented using the capabilities of LVM, and the LIO kernel target.

It exposes an HTTP/jsonrpc service that should allow it to integrate
with other projects such as libstoragemanagement or OpenStack Volume.

targetd is a brand new project -- I'm looking for potential contributors
(it's licensed under GPLv3) as well as feedback on the API, and what
targetd's future direction should be.

Please see https://github.com/agrover/targetd for code and more info.

Regards -- Andy
