From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13242] System Panics with emulex lpfc driver during the boot
Date: Wed, 6 May 2009 15:40:51 GMT
Message-ID: <200905061540.n46FepCU011706@demeter.kernel.org>
References: <bug-13242-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36716 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396AbZEFPkv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2009 11:40:51 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n46Fepto011707
	for <linux-scsi@vger.kernel.org>; Wed, 6 May 2009 15:40:51 GMT
In-Reply-To: <bug-13242-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13242





--- Comment #2 from Babu Moger <babu.moger@lsi.com>  2009-05-06 15:40:50 ---
I am sure I am using 2.6.30-rc4. You can see the messages below..

Pid: 687, comm: lpfc_worker_0 Not tainted 2.6.30-rc4 #1 PowerEdge 2900

About the version of lpfc version, looking at the sources I am seeing the
following text in lpfc_version.h

#define LPFC_DRIVER_VERSION "8.3.0"

If you have any other patch on top of this please send me across. I will test
and let you know.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
