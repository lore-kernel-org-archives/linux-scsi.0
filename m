From: adam radford <aradford@gmail.com>
Subject: [PATCH 5/5] megaraid_sas: Version and Changelog update
Date: Mon, 10 Mar 2014 02:52:03 -0700
Message-ID: <CAHtARFErkgrf_zkGsJaxv03manSyuvDE=mO0Q9F5Wgk+3qA2Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf303a323b46fa5104f43d8e7c
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:48121 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaCJJwE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2014 05:52:04 -0400
Received: by mail-yh0-f52.google.com with SMTP id c41so157282yho.25
        for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2014 02:52:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>

--20cf303a323b46fa5104f43d8e7c
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas updates the driver version to
v06.803.01.00-rc1, and updates Documentation/scsi/ChangeLog.megaraid_sas.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc.old/Documentation/scsi/ChangeLog.megaraid_sas
scsi-misc.new/Documentation/scsi/ChangeLog.megaraid_sas
--- scsi-misc.old/Documentation/scsi/ChangeLog.megaraid_sas 2014-03-09
14:53:01.000000000 -0700
+++ scsi-misc.new/Documentation/scsi/ChangeLog.megaraid_sas 2014-03-10
01:27:05.779857022 -0700
@@ -1,3 +1,16 @@
+Release Date    : Mon. Mar 10, 2014 17:00:00 PST 2014 -
+ (emaild-id:megaraidlinux@lsi.com)
+ Adam Radford
+ Kashyap Desai
+ Sumit Saxena
+Current Version : 06.803.01.00-rc1
+Old Version     : 06.700.06.00-rc1
+    1. Load correct raid context timeout value for multipathing & clustering.
+    2. Fix megasas_ioc_init_fusion to use local stack variable.
+    3. Return leaked MPT frames to MPT command pool.
+    4. Add Dell PowerEdge VRTX SR-IOV VF device support.
+    5. Version and Changelog update.
+-------------------------------------------------------------------------------
 Release Date    : Sat. Aug 31, 2013 17:00:00 PST 2013 -
  (emaild-id:megaraidlinux@lsi.com)
  Adam Radford
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_base.c 2014-03-10
01:21:11.905980715 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c 2014-03-10
01:21:52.868980752 -0700
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : 06.700.06.00-rc1
+ *  Version : 06.803.01.00-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas.h 2014-03-10
01:21:11.907980210 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h 2014-03-10
01:22:31.744856918 -0700
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION "06.700.06.00-rc1"
-#define MEGASAS_RELDATE "Aug. 31, 2013"
-#define MEGASAS_EXT_VERSION "Sat. Aug. 31 17:00:00 PDT 2013"
+#define MEGASAS_VERSION "06.803.01.00-rc1"
+#define MEGASAS_RELDATE "Mar. 10, 2014"
+#define MEGASAS_EXT_VERSION "Mon. Mar. 10 17:00:00 PDT 2014"

 /*
  * Device IDs

--20cf303a323b46fa5104f43d8e7c
Content-Type: application/octet-stream; name="megaraid_sas.patch5"
Content-Disposition: attachment; filename="megaraid_sas.patch5"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hslki9a30

ZGlmZiAtTmF1ciBzY3NpLW1pc2Mub2xkL0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVn
YXJhaWRfc2FzIHNjc2ktbWlzYy5uZXcvRG9jdW1lbnRhdGlvbi9zY3NpL0NoYW5nZUxvZy5tZWdh
cmFpZF9zYXMKLS0tIHNjc2ktbWlzYy5vbGQvRG9jdW1lbnRhdGlvbi9zY3NpL0NoYW5nZUxvZy5t
ZWdhcmFpZF9zYXMJMjAxNC0wMy0wOSAxNDo1MzowMS4wMDAwMDAwMDAgLTA3MDAKKysrIHNjc2kt
bWlzYy5uZXcvRG9jdW1lbnRhdGlvbi9zY3NpL0NoYW5nZUxvZy5tZWdhcmFpZF9zYXMJMjAxNC0w
My0xMCAwMToyNzowNS43Nzk4NTcwMjIgLTA3MDAKQEAgLTEsMyArMSwxNiBAQAorUmVsZWFzZSBE
YXRlICAgIDogTW9uLiBNYXIgMTAsIDIwMTQgMTc6MDA6MDAgUFNUIDIwMTQgLQorCQkJKGVtYWls
ZC1pZDptZWdhcmFpZGxpbnV4QGxzaS5jb20pCisJCQlBZGFtIFJhZGZvcmQKKwkJCUthc2h5YXAg
RGVzYWkKKwkJCVN1bWl0IFNheGVuYQorQ3VycmVudCBWZXJzaW9uIDogMDYuODAzLjAxLjAwLXJj
MQorT2xkIFZlcnNpb24gICAgIDogMDYuNzAwLjA2LjAwLXJjMQorICAgIDEuIExvYWQgY29ycmVj
dCByYWlkIGNvbnRleHQgdGltZW91dCB2YWx1ZSBmb3IgbXVsdGlwYXRoaW5nICYgY2x1c3Rlcmlu
Zy4KKyAgICAyLiBGaXggbWVnYXNhc19pb2NfaW5pdF9mdXNpb24gdG8gdXNlIGxvY2FsIHN0YWNr
IHZhcmlhYmxlLgorICAgIDMuIFJldHVybiBsZWFrZWQgTVBUIGZyYW1lcyB0byBNUFQgY29tbWFu
ZCBwb29sLgorICAgIDQuIEFkZCBEZWxsIFBvd2VyRWRnZSBWUlRYIFNSLUlPViBWRiBkZXZpY2Ug
c3VwcG9ydC4KKyAgICA1LiBWZXJzaW9uIGFuZCBDaGFuZ2Vsb2cgdXBkYXRlLgorLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQogUmVsZWFzZSBEYXRlICAgIDogU2F0LiBBdWcgMzEsIDIwMTMgMTc6MDA6
MDAgUFNUIDIwMTMgLQogCQkJKGVtYWlsZC1pZDptZWdhcmFpZGxpbnV4QGxzaS5jb20pCiAJCQlB
ZGFtIFJhZGZvcmQKZGlmZiAtTmF1ciBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFp
ZC9tZWdhcmFpZF9zYXNfYmFzZS5jIHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlk
L21lZ2FyYWlkX3Nhc19iYXNlLmMKLS0tIHNjc2ktbWlzYy5vbGQvZHJpdmVycy9zY3NpL21lZ2Fy
YWlkL21lZ2FyYWlkX3Nhc19iYXNlLmMJMjAxNC0wMy0xMCAwMToyMToxMS45MDU5ODA3MTUgLTA3
MDAKKysrIHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19i
YXNlLmMJMjAxNC0wMy0xMCAwMToyMTo1Mi44Njg5ODA3NTIgLTA3MDAKQEAgLTE4LDcgKzE4LDcg
QEAKICAqICBGb3VuZGF0aW9uLCBJbmMuLCA1OSBUZW1wbGUgUGxhY2UsIFN1aXRlIDMzMCwgQm9z
dG9uLCBNQSAwMjExMS0xMzA3IFVTQQogICoKICAqICBGSUxFOiBtZWdhcmFpZF9zYXNfYmFzZS5j
Ci0gKiAgVmVyc2lvbiA6IDA2LjcwMC4wNi4wMC1yYzEKKyAqICBWZXJzaW9uIDogMDYuODAzLjAx
LjAwLXJjMQogICoKICAqICBBdXRob3JzOiBMU0kgQ29ycG9yYXRpb24KICAqICAgICAgICAgICBT
cmVlbml2YXMgQmFnYWxrb3RlCmRpZmYgLU5hdXIgc2NzaS1taXNjLm9sZC9kcml2ZXJzL3Njc2kv
bWVnYXJhaWQvbWVnYXJhaWRfc2FzLmggc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJh
aWQvbWVnYXJhaWRfc2FzLmgKLS0tIHNjc2ktbWlzYy5vbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlk
L21lZ2FyYWlkX3Nhcy5oCTIwMTQtMDMtMTAgMDE6MjE6MTEuOTA3OTgwMjEwIC0wNzAwCisrKyBz
Y3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAkyMDE0LTAz
LTEwIDAxOjIyOjMxLjc0NDg1NjkxOCAtMDcwMApAQCAtMzMsOSArMzMsOSBAQAogLyoKICAqIE1l
Z2FSQUlEIFNBUyBEcml2ZXIgbWV0YSBkYXRhCiAgKi8KLSNkZWZpbmUgTUVHQVNBU19WRVJTSU9O
CQkJCSIwNi43MDAuMDYuMDAtcmMxIgotI2RlZmluZSBNRUdBU0FTX1JFTERBVEUJCQkJIkF1Zy4g
MzEsIDIwMTMiCi0jZGVmaW5lIE1FR0FTQVNfRVhUX1ZFUlNJT04JCQkiU2F0LiBBdWcuIDMxIDE3
OjAwOjAwIFBEVCAyMDEzIgorI2RlZmluZSBNRUdBU0FTX1ZFUlNJT04JCQkJIjA2LjgwMy4wMS4w
MC1yYzEiCisjZGVmaW5lIE1FR0FTQVNfUkVMREFURQkJCQkiTWFyLiAxMCwgMjAxNCIKKyNkZWZp
bmUgTUVHQVNBU19FWFRfVkVSU0lPTgkJCSJNb24uIE1hci4gMTAgMTc6MDA6MDAgUERUIDIwMTQi
CiAKIC8qCiAgKiBEZXZpY2UgSURzCg==
--20cf303a323b46fa5104f43d8e7c--
