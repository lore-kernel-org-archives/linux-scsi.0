From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 0/2] target: I/O topology for block backstores
Date: Mon, 11 Nov 2013 08:59:16 -0800
Message-ID: <1384189158-19913-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab3KKQ71 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Nov 2013 11:59:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hi Nab,

Here's a patch from October, along with a trivial cleanup. hch had
concerns about the four function pointers added to struct
se_subsystem_api, but was OK with it for now.

Please apply -- Andy

