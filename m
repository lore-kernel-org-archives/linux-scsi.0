From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15288] kernel 2.6.31 loading goes in loop on IBM xSeries 330
Date: Mon, 15 Feb 2010 12:02:50 GMT
Message-ID: <201002151202.o1FC2o66013718@demeter.kernel.org>
References: <bug-15288-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48745 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab0BOMCu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2010 07:02:50 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1FC2o0n013719
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2010 12:02:50 GMT
In-Reply-To: <bug-15288-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15288





--- Comment #6 from Domenico Palumbo <domenico.palumbo@ingsoft.it>  2010-02-15 12:02:48 ---
Created an attachment (id=25046)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=25046)
Screen shot of boot using option scsi_mod.scan=sync

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
