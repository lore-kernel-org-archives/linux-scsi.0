From: Jayamohan Kalickal <JayamohanKalickal-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Subject: [PATCH 1/4] RFC: beiscsi driver
Date: Sun, 26 Jul 2009 20:11:30 -0700
Message-ID: <20090727031130.GG4550@localhost.localdomain>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+xNpyl7Qekk2NvDX"
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


--+xNpyl7Qekk2NvDX
Content-Type: text/plain


--~--~---------~--~----~------------~-------~--~----~
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi
-~----------~----~----~----~------~----~------~--~---


--+xNpyl7Qekk2NvDX
Content-Type: text/plain
Content-Disposition: attachment;
	filename="0001-RFC-beiscsi-driver.patch"

>From 665c7b21740519eaaca8fb3c7fef0f8de3450b35 Mon Sep 17 00:00:00 2001
From: Jayamohan Kallickal <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
Date: Sun, 26 Jul 2009 19:00:46 -0700
Subject: [PATCH 1/4] RFC: beiscsi driver

   The  open-iscsi based storage driver for ServerEngines
10 Gbps Adapter. The Adapter is Multi-Function device
that provides NIC/iSCSI/FCOE Functionality.

   The driver works in Full Hardware Offload mode utilizing
the hooks provided by open-iscsi layer.

Signed-off-by: Jayamohan Kallickal <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ebc2691..9bd8a71 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5253,6 +5253,14 @@ W:	http://www.serverengines.com
 S:	Supported
 F:	drivers/net/benet/
 
+SERVER ENGINES 10Gbps iSCSI - BladeEngine 2 DRIVER
+P:	Jayamohan Kallickal
+M:	jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org
+L:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+W:	http://www.serverengines.com
+S:	Supported
+F:	drivers/scsi/beiscsi/
+
 SFC NETWORK DRIVER
 P:	Steve Hodgson
 P:	Ben Hutchings
-- 
1.6.3


--+xNpyl7Qekk2NvDX--
