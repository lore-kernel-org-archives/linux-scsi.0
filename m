From: James Smart <James.Smart@Emulex.Com>
Subject: missed patch: Block I/O while SG reset operation in progress
Date: Wed, 17 May 2006 10:02:31 -0400
Message-ID: <446B2CF7.5000101@emulex.com>
References: <20060516230233.39830.qmail@web31813.mail.mud.yahoo.com> <1147821176.3505.101.camel@mulgrave.il.steeleye.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44933 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932558AbWEQOAG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 10:00:06 -0400
In-Reply-To: <1147821176.3505.101.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James,

The following patch seems to be missed in scsi-misc-2.6.

http://marc.theaimsgroup.com/?l=linux-scsi&m=114184745819730&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114184745830216&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114184745819007&w=2

Please advise...

-- james s




List:       linux-scsi
Subject:    [PATCH Repost 0/2] Block I/O while SG reset operation in progress
From:       James Smart
Date:       2006-03-08 19:49:47

Following the discussion with Mike Anderson on the original patch:
http://marc.theaimsgroup.com/?l=linux-scsi&m=114081263725777&w=2
and
http://marc.theaimsgroup.com/?l=linux-scsi&m=114080001928462&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114080001916527&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114080002012180&w=2

I've implemented the missing item of waking up those waiting for
recovery to complete as well as restarting queues that may have
been stopped.

In conversations with Mike, it's agreed that this patch is sufficient
to block i/o while performing resets via SG - the original immediate goal.
However, we've noted several other issues in this interface that will
need to be addressed eventually.

-- james s
