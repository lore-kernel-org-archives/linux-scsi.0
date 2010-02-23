From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15341] Load goes up very high when we traverse the large tree
Date: Tue, 23 Feb 2010 22:24:39 GMT
Message-ID: <201002232224.o1NMOdb6007806@demeter.kernel.org>
References: <bug-15341-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57432 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab0BWWYk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 17:24:40 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1NMOd7i007807
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2010 22:24:40 GMT
In-Reply-To: <bug-15341-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15341





--- Comment #11 from Jens Axboe <axboe@kernel.dk>  2010-02-23 22:24:32 ---
Would it be possible for you to test 2.6.33-rc8?

And in the interest of fixing 2.6.32 as well, are you familiar with using git
and git bisect in particular? It would be a very restricted set of commits,
since we are dealing with a single file only.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
