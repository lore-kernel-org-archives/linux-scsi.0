From: Willem Riede <wrlk@riede.org>
Subject: ide-scsi: Strange, packet command initiated yet DRQ isn't asserted
Date: Sun, 3 Nov 2002 19:42:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021104004258.GS13860@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.11.6/8.11.6) with ESMTP id gA40gwC30745
	for <linux-scsi@vger.kernel.org>; Sun, 3 Nov 2002 19:42:58 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Does anyone have a pointer as to what I'm likely to do wrong when ide-scsi
reports "Strange, packet command initiated yet DRQ isn't asserted".

This happens when I access a DI-30 ide OnStream drive with an overhauled
osst though ide-scsi on 2.5.44 kernel.

Thanks, Willem Riede.

