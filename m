From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 22512] no disks are found at driver start after upgrate from
 2.6.35.8 to 2.6.36
Date: Wed, 10 Nov 2010 18:07:43 GMT
Message-ID: <201011101807.oAAI7hV1005786@demeter2.kernel.org>
References: <bug-22512-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:57070 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab0KJSHo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2010 13:07:44 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oAAI7hXx005787
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2010 18:07:43 GMT
In-Reply-To: <bug-22512-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=22512





--- Comment #2 from cunio@agora.pl  2010-11-10 18:07:42 ---
This patch seems to be already applied to 2.6.36.
Here you are part of qla24xx_logio_entry

                if (iop[0] & BIT_4) {
                        fcport->port_type = FCT_TARGET;
                        if (iop[0] & BIT_8)
                                fcport->flags |= FCF_FCP2_DEVICE;
                } else if (iop[0] & BIT_5)
                        fcport->port_type = FCT_INITIATOR;

                if (logio->io_parameter[7] || logio->io_parameter[8])

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
