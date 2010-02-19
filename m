From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15341] Load goes up very high when we traverse the large tree
Date: Fri, 19 Feb 2010 17:01:57 GMT
Message-ID: <201002191701.o1JH1vNU007883@demeter.kernel.org>
References: <bug-15341-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59908 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab0BSRB6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2010 12:01:58 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1JH1vT6007884
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 17:01:57 GMT
In-Reply-To: <bug-15341-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15341





--- Comment #5 from Andrew Morton <akpm@linux-foundation.org>  2010-02-19 17:01:21 ---
Please do an `echo w > /proc/sysrq-trigger' then run `dmesg' so we can see
where these D-state tasks are stuck.

Please use bugzilla attachments, as copy-n-paste wordwraps the text which makes
a real mess these dumps.

Thanks.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
