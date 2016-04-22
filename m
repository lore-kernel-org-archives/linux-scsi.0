From: <adheer.chandravanshi-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] iscsi: Add statistics support for iscsi host
Date: Fri, 22 Apr 2016 09:39:30 -0400
Message-ID: <1461332373-18491-1-git-send-email-adheer.chandravanshi@qlogic.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBC35NFWBRAHBB6HG5C4AKGQEYADDWTA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
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

The following patches add the support to maintain some iscsi initiator
stats at the iscsi host level. The stats will be exposed using iscsi
host sysfs attrs.

This adds support for following stats:
       ISCSI_HOST_PARAM_LOGIN_ACCEPT_RSPS
       ISCSI_HOST_PARAM_LOGIN_OTHER_FAILS
       ISCSI_HOST_PARAM_LOGIN_AUTHENTICATION_FAILS
       ISCSI_HOST_PARAM_LOGIN_AUTHORIZATION_FAILS
       ISCSI_HOST_PARAM_LOGIN_NEGOTIATION_FAILS
       ISCSI_HOST_PARAM_LOGIN_REDIRECT_RSPS
       ISCSI_HOST_PARAM_LOGOUT_NORMAL_RSPS
       ISCSI_HOST_PARAM_LOGOUT_OTHER_RSPS
       ISCSI_HOST_PARAM_DIGEST_ERR
       ISCSI_HOST_PARAM_TIMEOUT_ERR
       ISCSI_HOST_PARAM_FORMAT_ERR
       ISCSI_HOST_PARAM_SESSION_FAILS


Adheer Chandravanshi (3):
  scsi_transport_iscsi: Add support for stats param at host level
  libiscsi: Add support to update host stats param
  bnx2i: Enable support for host stats param

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
