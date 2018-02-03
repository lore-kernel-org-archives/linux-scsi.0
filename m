From: Laurence Oberman <loberman@redhat.com>
Subject: Request for input on new options for scsi_debug driver
Date: Sat, 03 Feb 2018 11:54:14 -0500
Message-ID: <1517676854.18584.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:41051 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752400AbeBCQyQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Feb 2018 11:54:16 -0500
Received: by mail-qt0-f169.google.com with SMTP id r13so1318020qtm.8
        for <linux-scsi@vger.kernel.org>; Sat, 03 Feb 2018 08:54:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert <dgilbert@interlog.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hello

During various fault injection scenarios it would be useful to be able
to pick a specific starting sector and number of follow on sectors
where a MEDIUM ERROR for reads would be returned against a scsi-debug
device.

Right now this only works against sector 0x1234 and OPT_MEDIUM_ERR_NUM
follow on sectors.
However during testing of md-raid and other scenarios I wanted more
flexibility.

The idea is add 2 new parameters:
medium_error_start
medium_error_count

If medium_error_start is set then we don't use the default of
OPT_MEDIUM_ERR_ADDR, but use that set value.
If medium_error_count is set we use that value otherwise default to
OPT_MEDIUM_ERR_NUM.

Should I send a patch for this, wanted to find out if this would be
acceptable before I waste anybody's time having to review.

Regards
Laurence Oberman
