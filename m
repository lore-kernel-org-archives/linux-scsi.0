From: Jiri Slaby <jslaby@suse.cz>
Subject: Why is AHA152X_CS !64BIT?
Date: Mon, 23 Aug 2010 21:59:12 +0200
Message-ID: <4C72D310.4040004@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64550 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab0HWT7S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2010 15:59:18 -0400
Received: by bwz11 with SMTP id 11so4227175bwz.19
        for <linux-scsi@vger.kernel.org>; Mon, 23 Aug 2010 12:59:17 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fischer@linux-buechse.de
Cc: linux-scsi@vger.kernel.org

Hi,

I see that the aha152x driver for pcmcia is marked as unsupported on
64bit. But I also see a patch [1] which removes the restriction based on
user's testing in bugzilla [2].

Is there a reason why it would have to be marked as !64BIT? I'm asking
because there is an opensuse user with this card who updated to 64-bit
distro and lost this driver thereafter.

[1] http://kerneltrap.org/mailarchive/linux-scsi/2010/3/6/6832393
[2] https://bugzilla.kernel.org/show_bug.cgi?id=14333

thanks,
-- 
js
suse labs
