From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17822] drivers/scsi/ipr.c implicit declaration of function
 'writeq'
Date: Mon, 6 Sep 2010 13:31:18 GMT
Message-ID: <201009061331.o86DVI1W028034@demeter1.kernel.org>
References: <bug-17822-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57955 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab0IFNbU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 09:31:20 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o86DVJw8028035
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 6 Sep 2010 13:31:19 GMT
In-Reply-To: <bug-17822-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=17822





--- Comment #3 from Teej <xteejyx@googlemail.com>  2010-09-06 13:31:17 ---
That does look very similar to this problem, but of course in another driver.
Strangely, that is also ppc.
I have also had the same error in the 2.6.35-r5 kernel sources in Gentoo, so
this hasn't since been noticed/fixed and has in fact regressed.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
