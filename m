From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Mon, 15 Feb 2010 16:42:21 GMT
Message-ID: <201002151642.o1FGgLMG007771@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59148 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab0BOQmX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2010 11:42:23 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1FGgLuR007772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2010 16:42:21 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783


Ian Goodacre <Ian.Goodacre@xtra.co.nz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |Ian.Goodacre@xtra.co.nz




--- Comment #30 from Ian Goodacre <Ian.Goodacre@xtra.co.nz>  2010-02-15 16:42:10 ---
(In reply to comment #8)
> After I entered "hal-disable-polling --device /dev/scd0"...

I had to run "hal-disable-polling --device /dev/sr0" three times before the
stream of events stopped. I now have three files in /etc/hal/fdi/information:

media-check-disable-storage_model_DVD_RW_AD_7580S.fdi
media-check-disable-storage_model_Optiarc_DVD_RW_AD_7580S_0.fdi
media-check-disable-storage_model_Optiarc_DVD_RW_AD_7580S.fdi

They were produced in the order listed.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
