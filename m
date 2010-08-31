From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17551] mpt2sas -- spurious hotplug event causes drive drop to
 drop out of JBOD array
Date: Tue, 31 Aug 2010 08:23:26 GMT
Message-ID: <201008310823.o7V8NQpp006739@demeter1.kernel.org>
References: <bug-17551-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39389 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab0HaIX1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2010 04:23:27 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7V8NQQ5006744
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 31 Aug 2010 08:23:26 GMT
In-Reply-To: <bug-17551-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=17551





--- Comment #6 from starlight@binnacle.cx  2010-08-31 08:23:09 ---
Hardware details:

Supermicro 1026T-URF
two Intel / Xeon X5560 2.8GHz / 1333MHz / 8MB L3 / D0
Hynix / ECC UDIMM HMT351U7AFR8C-H9 / 1333MHz / 4GB x 6 = 24GB
Supermicro AOC-USAS2-L8i SAS controller

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
