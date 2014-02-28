From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 0/2] megaraid_sas: fix a small problem when reading state value from hw
Date: Fri, 28 Feb 2014 15:54:35 +0100
Message-ID: <1393599277-30904-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbaB1OzX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Feb 2014 09:55:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>

Hi all,

I have posted almost the same fix back 2011 http://www.spinics.net/lists/linux-scsi/msg50624.html
now it looks like someone was really hit by the hw read race.
This patch is split into two part - the first patch fixes the actual race,
the second is a bonus, it just removes some almost unused variables from the same function
with no functional change.


Tomas Henzl (2):
  megaraid_sas: fix a small problem when reading state value from hw
  megaraid_sas: remove unused variables

 drivers/scsi/megaraid/megaraid_sas_base.c | 68 ++++++++-----------------------
 1 file changed, 18 insertions(+), 50 deletions(-)

-- 
1.8.3.1

