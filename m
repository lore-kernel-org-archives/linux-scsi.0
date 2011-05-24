From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Reduce error recovery time by reducing use of TURs
Date: Tue, 24 May 2011 12:53:07 -0400
Message-ID: <1306255988.10201.11.camel@mulgrave.site>
References: <4DD56448.7060003@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36727 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648Ab1EXVcJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2011 17:32:09 -0400
In-Reply-To: <4DD56448.7060003@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Jeffery <dhjeffery@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2011-05-19 at 14:41 -0400, David Jeffery wrote:
> This is a resend of a patch with some minor whitespace cleanups which I'd
> like to have considered for inclusion.

Not enough, though:

WARNING: line over 80 characters
#53: FILE: drivers/scsi/scsi_error.c:964:
+static int scsi_eh_test_devices(struct list_head *cmd_list, struct
list_head *work_q, struct list_head *done_q, int try_stu)

ERROR: trailing whitespace
#63: FILE: drivers/scsi/scsi_error.c:974:
+^I^Ifinish_cmds = !scsi_device_online(scmd->device) || $

WARNING: line over 80 characters
#64: FILE: drivers/scsi/scsi_error.c:975:
+                       (try_stu && !scsi_eh_try_stu(scmd) && !
scsi_eh_tur(scmd)) ||

ERROR: trailing whitespace
#66: FILE: drivers/scsi/scsi_error.c:977:
+^I^I^I$

ERROR: space required before the open parenthesis '('
#196: FILE: drivers/scsi/scsi_error.c:1303:
+               } else if(rtn == FAST_IO_FAIL) {

total: 3 errors, 2 warnings, 172 lines checked

checkpatch.pl is your friend ...

This is pretty trivial, so I fixed it up manually (I usually only care
about errors, but in this case the warning about the function template
and long line needed fixing to match the file).

James


