From: matthias@kaehlcke.net
Subject: [patch 0/2] QLA2xxx: Convert semaphores to mutexes
Date: Sun, 04 May 2008 20:45:59 +0200
Message-ID: <20080504184559.243525572@kaehlcke.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.riseup.net ([204.13.164.18]:39005 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758109AbYEDTZu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 May 2008 15:25:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org

QLA2XXX driver: The semaphores qla_fw_lock and vport_sem are used as mutexes. Convert them to the muxex API

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
