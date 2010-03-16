From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15503] insmod: error inserting '/lib/aic7xxx.ko': -1 Invalid
 modulkjournald starting
Date: Tue, 16 Mar 2010 02:29:29 GMT
Message-ID: <201003160229.o2G2TTTU006341@demeter.kernel.org>
References: <bug-15503-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55714 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877Ab0CPC3a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2010 22:29:30 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2G2TTFt006342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2010 02:29:30 GMT
In-Reply-To: <bug-15503-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15503





--- Comment #4 from Will L Givens <wlgivens@gmail.com>  2010-03-16 02:29:03 ---
Created an attachment (id=25542)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=25542)
Found a patch for the 'section mismatch'

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
