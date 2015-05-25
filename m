From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] be2iscsi change of ownership from Emulex to Avago
 Technologies recently.  We like to get the following updates in:   changed
 "Emulex" to "Avago Technologies",   changed email addresses from
 "emulex.com" to "avagotech.com",   updated MAINTAINER list for be2iscsi
 driver.
Date: Mon, 25 May 2015 09:12:20 -0700
Message-ID: <1432570340.2195.3.camel@HansenPartnership.com>
References: <1431670577-4125-1-git-send-email-minh.tran@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50215 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546AbbEYQMW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 May 2015 12:12:22 -0400
In-Reply-To: <1431670577-4125-1-git-send-email-minh.tran@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Minh Tran <minhduc.tran@avagotech.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Minh Tran <minh.tran@avagotech.com>, Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>

On Thu, 2015-05-14 at 23:16 -0700, Minh Tran wrote:
> Signed-off-by: Minh Tran <minh.tran@avagotech.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>
> ---
>  MAINTAINERS                      |  6 ++++--
>  drivers/scsi/be2iscsi/be.h       |  6 +++---
>  drivers/scsi/be2iscsi/be_cmds.c  |  6 +++---
>  drivers/scsi/be2iscsi/be_cmds.h  |  6 +++---
>  drivers/scsi/be2iscsi/be_iscsi.c |  8 ++++----
>  drivers/scsi/be2iscsi/be_iscsi.h |  8 ++++----
>  drivers/scsi/be2iscsi/be_main.c  | 12 ++++++------
>  drivers/scsi/be2iscsi/be_main.h  | 10 +++++-----
>  drivers/scsi/be2iscsi/be_mgmt.c  |  8 ++++----
>  drivers/scsi/be2iscsi/be_mgmt.h  |  8 ++++----
>  10 files changed, 40 insertions(+), 38 deletions(-)

This patch conflicts horribly with [PATCH V2 0/7] be2iscsi driver update
to 10.6.0.0.  I fixed it up this time, but next time, just update
MAINTAINERS on its own and sort out the rest during the usual merge
window process.

James


