From: James Courtier-Dutton <james.dutton@gmail.com>
Subject: sniffing scsi
Date: Sun, 15 Jan 2012 11:54:31 +0000
Message-ID: <CAAMvbhEcheTpAU1kX9nR=D+p3X6uWCu1uXEr6xaH3Wuezpcn+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:59779 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab2AOLyc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Jan 2012 06:54:32 -0500
Received: by qadc16 with SMTP id c16so786129qad.19
        for <linux-scsi@vger.kernel.org>; Sun, 15 Jan 2012 03:54:31 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Is it possible to monitor scsi messages on a particular bus.
E.g. Attach to /dev/sda or /dev/sr0 and capture all messages going between them.
Ideally, in such a way that wireshark can capture it.
We can do this for Ethernet and USB, but I cannot find SCSI bus capture.

KInd Regards

James
