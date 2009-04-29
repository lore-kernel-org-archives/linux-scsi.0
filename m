From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13143] scsi_debug doesn't manage more than 1Tb
Date: Wed, 29 Apr 2009 06:33:25 GMT
Message-ID: <200904290633.n3T6XPN9030268@demeter.kernel.org>
References: <bug-13143-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58376 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbZD2GdZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 02:33:25 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3T6XPrN030269
	for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2009 06:33:25 GMT
In-Reply-To: <bug-13143-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13143





--- Comment #6 from Thierry Vignaud <tvignaud@mandriva.com>  2009-04-29 06:31:39 ---
It fixes it indeed.
You can queue it for upstream :-)

    Reported-and-tested-by: Thierry Vignaud <tvignaud@mandriva.com>

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
