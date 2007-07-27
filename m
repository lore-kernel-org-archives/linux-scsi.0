From: "Ashish Sood" <ashishsood@gmail.com>
Subject: questions on scsi_level & Read command?
Date: Fri, 27 Jul 2007 09:46:09 +0530
Message-ID: <87a7e2a0707262116q24f0f0edoefeddbff71df4605@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:20443 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbXG0EQK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 00:16:10 -0400
Received: by ug-out-1314.google.com with SMTP id j3so645773ugf
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jul 2007 21:16:09 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

 I am newbie on SCSI.

Seems like scsi_level comes in response to the inquiry command.

/*
 *  struct scsi_device::scsi_level values. For SCSI devices other than those
 *  prior to SCSI-2 (i.e. over 12 years old) this value is (resp[2] + 1)
 *  where "resp" is a byte array of the response to an INQUIRY. The scsi_level
 *  variable is visible to the user via sysfs.
 */

#define SCSI_UNKNOWN    0
#define SCSI_1          1
#define SCSI_1_CCS      2
#define SCSI_2          3
#define SCSI_3          4        /* SPC */
#define SCSI_SPC_2      5
#define SCSI_SPC_3      6

I am curious to know as to how this information will be used
by scsi initiator?

Also, looks there are six different read commands


# 1 Read (6)
# 2 Read (10)
# 3 Read (12)
# 4 Read (16)
# 5 Read (32)
# 6 Read Long

How does scsi initiator know which command to use? Is it based on some
field which comes in response to the INQUIRY command.

Really appreciate if some one can throw some light.

Thanks,
Ashish
