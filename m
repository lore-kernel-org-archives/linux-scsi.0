From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Fri, 20 Nov 2009 08:15:13 GMT
Message-ID: <200911200815.nAK8FDwQ019088@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52467 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbZKTIPK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2009 03:15:10 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAK8FDZP019089
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2009 08:15:13 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783


Petr Stehlik <pstehlik@sophics.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |pstehlik@sophics.cz




--- Comment #22 from Petr Stehlik <pstehlik@sophics.cz>  2009-11-20 08:15:09 ---
With up-to-date Ubuntu Karmic Koala and its udev-147~-6.1 the problem is still
there (Acer Extensa 5630EZ with Optiarc DVD RW AD-7560S)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
