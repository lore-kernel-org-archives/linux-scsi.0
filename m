From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Conversion to generic boolean
Date: Sat, 26 Aug 2006 05:24:42 +0200
Message-ID: <44EFBEFA.2010707@student.ltu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:50563 "EHLO
	gepetto.dc.ltu.se") by vger.kernel.org with ESMTP id S1422929AbWHZDRm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Aug 2006 23:17:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Hello

Just would like to ask if you want patches for:

* (Most importent, may introduce bugs if left alone)
Fixing boolean checking, ex:
if (bool == FALSE)
to
if (!bool)

* (In effort to remove all local true/false definitions)
Converting FALSE and TRUE to the generic-boolean.patch (applied 060823 
in -mm).

* (Just more readable code, should not be prone for bugs if first * is 
fixed, if left alone)
Converting obvious boolean variables to actual boolean. Most of them are 
'int' right now.

(Please cc: me, not on the list)

Have a nice night
/Richard Knutsson
