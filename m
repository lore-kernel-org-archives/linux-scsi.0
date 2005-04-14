From: James.Smart@Emulex.Com
Subject: Heads up on 2.6.12-rc1 and later
Date: Thu, 14 Apr 2005 12:29:01 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AB9C@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61869 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261533AbVDNQ3G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2005 12:29:06 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Folks,

FYI:

In testing with 2.6.12-rc1 and -rc2, we've been encountering an issue on SMP machines with the loading of scsi_mod and sd_mod modules. The sd_mod load fails with unresolved symbols. It appears to be a race condition based on how quickly the modules load. This works fine on uni systems and on 2.6.11.

Evidently, this problem has been before and is resolved by a short delay between module loads. http://seclists.org/lists/linux-kernel/2005/Apr/0383.html

Given it's been around for 2 -rc itterations, I expect it needed some highlighting.

-- james s
