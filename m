From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: PROBLEM: Oops in 2.6.3 with lots of SG_IO activity - [PATCH]
Date: Tue, 9 Mar 2004 11:02:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <04Mar9.110218est.332557@cyborg.cybernetics.com>
References: <404DE2CE.5070200@us.ibm.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:15625 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S262014AbUCIQCX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Mar 2004 11:02:23 -0500
In-Reply-To: <404DE2CE.5070200@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: 'Brian King' <brking@us.ibm.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

I found a similar problem in 2.4 last year.  I posted a patch but it
wasn't merged due to a minor technicality with memory barriers, and I
forgot to follow up on the issue.  Sorry for dropping the ball on this
one.  See http://marc.theaimsgroup.com/?t=105664088400001&r=1&w=2.  I
believe the fix probably still needs to be merged in 2.4.

Anthony J. Battersby
Cybernetics

