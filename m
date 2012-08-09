From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 15/20] srp_transport: Document sysfs attributes
Date: Thu, 09 Aug 2012 15:58:13 +0000
Message-ID: <5023DE15.5040506@acm.org>
References: <5023DA39.7020000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5023DA39.7020000-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Robert Jennings <rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: Robert Jennings <rcj-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 Documentation/ABI/stable/sysfs-transport-srp |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-transport-srp

diff --git a/Documentation/ABI/stable/sysfs-transport-srp b/Documentation/ABI/stable/sysfs-transport-srp
new file mode 100644
index 0000000..7b0d4a5
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-transport-srp
@@ -0,0 +1,12 @@
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/port_id
+Date:		June 27, 2007
+KernelVersion:	2.6.24
+Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	16-byte local SRP port identifier in hexadecimal format. An
+		example: 4c:49:4e:55:58:20:56:49:4f:00:00:00:00:00:00:00.
+
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/roles
+Date:		June 27, 2007
+KernelVersion:	2.6.24
+Contact:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:	Role of the remote port. Either "SRP Initiator" or "SRP Target".
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
