From: Derek Richardson <derek.richardson@pgs.com>
Subject: Qlogic fibre drivers
Date: 21 May 2002 13:37:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1022006223.7660.11.camel@idoru.hstn.tensor.pgs.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hap.hstn.tensor.pgs.com (hap.hstn.tensor.pgs.com [157.147.128.1])
	by mailboy.pgs.com (8.9.3+Sun/8.9.3) with ESMTP id NAA28566
	for <linux-scsi@vger.kernel.org>; Tue, 21 May 2002 13:36:34 -0500 (CDT)
Received: from idoru.hstn.tensor.pgs.com (idoru.hstn.tensor.pgs.com [157.147.92.80])
	by hap.hstn.tensor.pgs.com (8.9.3/8.9.3) with ESMTP id NAA24651
	for <linux-scsi@vger.kernel.org>; Tue, 21 May 2002 13:37:10 -0500 (CDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

All,
Does anyone have any experiencing using the QLogic fibre drivers? 
Namely, the v5.x and (newer) 6.x versions.  I'm currently trying to
_disable_ multipathing/failover capabilities in the version that ships
w/ RedHat 7.3 (tho. I don't have to use this particular one, just a 5.x
or later) and having a hard time w/out modifying the driver's source
code.  Googling and looking at all the notes/docu. doesn't reveal any
parameters for the module, does anyone know of one?  If not, do you know
of how to disable it in the source code (yes, that's me being lazy and
not wanting to dig...).
Thanks,
Derek R.
-- 
Linux Technician
713-817-1197 (cell)
713-781-4000 x2269 (office)
"Majority rule only work if you're also 
considering individual rights.  Because you
can't have five wolves and one sheep voting
on what to have for supper."
-Larry Flynt
********************************************
* Best Buy Co. supports CD copy protection.*
* They operate Best Buy, Sam Goody,        *
* Suncoast and On Cue.                     *
* I'm boycotting them, are you?            *
********************************************

