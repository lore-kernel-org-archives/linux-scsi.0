From: adam radford <aradford@gmail.com>
Subject: [PATCH 2/4] megaraid_sas: Remove unused variables in megasas_instance
Date: Thu, 19 Jun 2014 17:31:38 -0700
Message-ID: <CAHtARFG1SLWu34=qJmFPnxzAHBjPFRO80VDGznx85+Ftu_haoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf303635bbdc3e6a04fc399d29
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:42833 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbaFTAbj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2014 20:31:39 -0400
Received: by mail-yk0-f179.google.com with SMTP id 20so2152243yks.24
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2014 17:31:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com

--20cf303635bbdc3e6a04fc399d29
Content-Type: text/plain; charset=UTF-8

James/linux-scsi,

The following patch for megaraid_sas removes some unused variables
from the megasas_instance structure.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-for-next.old/drivers/scsi/megaraid/megaraid_sas.h
scsi-for-next.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-for-next.old/drivers/scsi/megaraid/megaraid_sas.h 2014-06-19
15:03:05.000000000 -0700
+++ scsi-for-next.new/drivers/scsi/megaraid/megaraid_sas.h 2014-06-19
15:30:49.334075830 -0700
@@ -1633,8 +1633,6 @@
  struct timer_list sriov_heartbeat_timer;
  char skip_heartbeat_timer_del;
  u8 requestorId;
- u64 initiator_sas_address;
- u64 ld_sas_address[64];
  char PlasmaFW111;
  char mpio;
  int throttlequeuedepth;

--20cf303635bbdc3e6a04fc399d29
Content-Type: application/octet-stream; name="megaraid_sas.patch2"
Content-Disposition: attachment; filename="megaraid_sas.patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hwmr9gre0

ZGlmZiAtTmF1ciBzY3NpLWZvci1uZXh0Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzLmggc2NzaS1mb3ItbmV4dC5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlk
X3Nhcy5oCi0tLSBzY3NpLWZvci1uZXh0Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzLmgJMjAxNC0wNi0xOSAxNTowMzowNS4wMDAwMDAwMDAgLTA3MDAKKysrIHNjc2ktZm9y
LW5leHQubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAkyMDE0LTA2LTE5
IDE1OjMwOjQ5LjMzNDA3NTgzMCAtMDcwMApAQCAtMTYzMyw4ICsxNjMzLDYgQEAKIAlzdHJ1Y3Qg
dGltZXJfbGlzdCBzcmlvdl9oZWFydGJlYXRfdGltZXI7CiAJY2hhciBza2lwX2hlYXJ0YmVhdF90
aW1lcl9kZWw7CiAJdTggcmVxdWVzdG9ySWQ7Ci0JdTY0IGluaXRpYXRvcl9zYXNfYWRkcmVzczsK
LQl1NjQgbGRfc2FzX2FkZHJlc3NbNjRdOwogCWNoYXIgUGxhc21hRlcxMTE7CiAJY2hhciBtcGlv
OwogCWludCB0aHJvdHRsZXF1ZXVlZGVwdGg7Cg==
--20cf303635bbdc3e6a04fc399d29--
