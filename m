From: <adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] bnx2i: Enable support for host stats param
Date: Fri, 22 Apr 2016 09:39:33 -0400
Message-ID: <1461332373-18491-4-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1461332373-18491-1-git-send-email-adheer.chandravanshi@qlogic.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBC35NFWBRAHBB6PG5C4AKGQETOEPURI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1461332373-18491-1-git-send-email-adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shyam.sundar-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, lduncan-IBi9RG/b67k@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Adheer Chandravanshi <adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Adheer Chandravanshi <adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

This enables the support for host stats param.

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 7289437..8b44c9a 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2201,6 +2201,18 @@ static umode_t bnx2i_attr_is_visible(int param_type, int param)
 		case ISCSI_HOST_PARAM_NETDEV_NAME:
 		case ISCSI_HOST_PARAM_HWADDRESS:
 		case ISCSI_HOST_PARAM_IPADDRESS:
+		case ISCSI_HOST_PARAM_LOGIN_ACCEPT_RSPS:
+		case ISCSI_HOST_PARAM_LOGIN_OTHER_FAILS:
+		case ISCSI_HOST_PARAM_LOGIN_AUTHENTICATION_FAILS:
+		case ISCSI_HOST_PARAM_LOGIN_AUTHORIZATION_FAILS:
+		case ISCSI_HOST_PARAM_LOGIN_NEGOTIATION_FAILS:
+		case ISCSI_HOST_PARAM_LOGIN_REDIRECT_RSPS:
+		case ISCSI_HOST_PARAM_LOGOUT_NORMAL_RSPS:
+		case ISCSI_HOST_PARAM_LOGOUT_OTHER_RSPS:
+		case ISCSI_HOST_PARAM_DIGEST_ERR:
+		case ISCSI_HOST_PARAM_TIMEOUT_ERR:
+		case ISCSI_HOST_PARAM_FORMAT_ERR:
+		case ISCSI_HOST_PARAM_SESSION_FAILS:
 			return S_IRUGO;
 		default:
 			return 0;
-- 
1.8.3.1

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
