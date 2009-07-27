From: Jayamohan Kallickal <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
Subject: [PATCH 6/6] RFC: beiscsi: modified MAINTAINERS
Date: Mon, 27 Jul 2009 12:55:23 -0700
Message-ID: <1248724523-10999-7-git-send-email-jayamohank@serverengines.com>
References: <1248724523-10999-1-git-send-email-jayamohank@serverengines.com> <1248724523-10999-2-git-send-email-jayamohank@serverengines.com> <1248724523-10999-3-git-send-email-jayamohank@serverengines.com> <1248724523-10999-4-git-send-email-jayamohank@serverengines.com> <1248724523-10999-5-git-send-email-jayamohank@serverengines.com> <1248724523-10999-6-git-send-email-jayamohank@serverengines.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1248724523-10999-6-git-send-email-jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Jayamohan Kallickal <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


 The modified MAINTAINERS file for  adding beiscsi driver

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
