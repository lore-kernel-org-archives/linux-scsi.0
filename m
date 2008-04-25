From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 0/5] aic7xxx: debloat
Date: Fri, 25 Apr 2008 04:46:38 +0200
Message-ID: <200804250446.38466.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:41171 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbYDYCrv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 22:47:51 -0400
Received: by fg-out-1718.google.com with SMTP id l27so3384743fgb.17
        for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2008 19:47:50 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

The pathches I just sent were tested with four .configs
with different combinations of firmware build, debug
and pretty-printing options for aic7xxx.

Size difference:

   text    data     bss     dec     hex filename
 262976   47922    1188  312086   4c316 scsi-misc-2.6-2008_04_15.org-BUILDFW/drivers/scsi/aic7xxx/built-in.o
 211224    2346    1188  214758   346e6 scsi-misc-2.6-2008_04_15.pU-BUILDFW/drivers/scsi/aic7xxx/built-in.o

 262976   47922    1188  312086   4c316 scsi-misc-2.6-2008_04_15.org-DEBUG/drivers/scsi/aic7xxx/built-in.o
 211224    2346    1188  214758   346e6 scsi-misc-2.6-2008_04_15.pU-DEBUG/drivers/scsi/aic7xxx/built-in.o

 243399   47922    1172  292493   4768d scsi-misc-2.6-2008_04_15.org-NDEBUG/drivers/scsi/aic7xxx/built-in.o
 203807    2346    1172  207325   329dd scsi-misc-2.6-2008_04_15.pU-NDEBUG/drivers/scsi/aic7xxx/built-in.o

 209896   28258    1172  239326   3a6de scsi-misc-2.6-2008_04_15.org-NDEBUG_NPRETTY/drivers/scsi/aic7xxx/built-in.o
 183966    2346    1172  187484   2dc5c scsi-misc-2.6-2008_04_15.pU-NDEBUG_NPRETTY/drivers/scsi/aic7xxx/built-in.o
--
vda
