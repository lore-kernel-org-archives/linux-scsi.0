From: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Subject: [PATCH] scsi: ibmvscsi: ibmvfc.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Thu, 31 Jul 2014 00:15:58 +0200
Message-ID: <1406758559-20836-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

And as I understand it, it is fine to replace strncpy to strlcpy here.
But if any of this code do not want a null terminated, or want to have the whole rest of size filled with null characters. 
If that is the case this is not a good patch.

Rickard Strandqvist (1):
  scsi: ibmvscsi: ibmvfc.c:  Cleaning up missing null-terminate in conjunction with
    strncpy

 drivers/scsi/ibmvscsi/ibmvfc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
