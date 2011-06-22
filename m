From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 37042] linux 3.0.0-rc2 libata-eh.c:4018
 ata_scsi_port_error_handler+0x80/0x53d on s2disk
Date: Wed, 22 Jun 2011 08:18:42 GMT
Message-ID: <201106220818.p5M8IgIW028497@demeter1.kernel.org>
References: <bug-37042-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:46025 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab1FVISn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2011 04:18:43 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p5M8Igki028499
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2011 08:18:42 GMT
In-Reply-To: <bug-37042-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=37042


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |akpm@linux-foundation.org
          Component|SCSI                        |Serial ATA
         AssignedTo|linux-scsi@vger.kernel.org  |jgarzik@pobox.com

Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org,
                   |                            |maciej.rutecki@gmail.com,
                   |                            |rjw@sisk.pl
             Blocks|                            |32012, 7216




--- Comment #2 from Florian Mickler <florian@mickler.org>  2011-06-22 08:18:38 ---
Does this help: http://www.spinics.net/lists/dri-devel/msg12162.html ?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
