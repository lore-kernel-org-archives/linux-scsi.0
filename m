From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 33802] list_del corruption in sd driver since 2.6.39-rc4
Date: Thu, 21 Apr 2011 21:49:42 GMT
Message-ID: <201104212149.p3LLngLM023339@demeter1.kernel.org>
References: <bug-33802-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:56505 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab1DUVtm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2011 17:49:42 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p3LLngwY023340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2011 21:49:42 GMT
In-Reply-To: <bug-33802-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=33802


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org,
                   |                            |maciej.rutecki@gmail.com,
                   |                            |rjw@sisk.pl
             Blocks|                            |32012




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
