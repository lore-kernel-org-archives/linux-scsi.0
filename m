From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/10] qla2xxx: updates for 2.6.26 [8.02.01-k2].
Date: Thu, 24 Apr 2008 17:31:50 -0500
Message-ID: <1209076310.3121.26.camel@localhost.localdomain>
References: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58932 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516AbYDXWby (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2008 18:31:54 -0400
In-Reply-To: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

On Thu, 2008-04-24 at 15:19 -0700, Andrew Vasquez wrote:
> This patchset contains fixes/updates for 2.6.26.
> 
>  drivers/scsi/qla2xxx/qla_dbg.c     |  394 +++++++++++++-----------------------
>  drivers/scsi/qla2xxx/qla_fw.h      |   26 +--
>  drivers/scsi/qla2xxx/qla_gbl.h     |    4 -
>  drivers/scsi/qla2xxx/qla_gs.c      |    4 +-
>  drivers/scsi/qla2xxx/qla_init.c    |    2 +-
>  drivers/scsi/qla2xxx/qla_isr.c     |    4 +-
>  drivers/scsi/qla2xxx/qla_mbx.c     |   19 +-
>  drivers/scsi/qla2xxx/qla_os.c      |   12 +-
>  drivers/scsi/qla2xxx/qla_version.h |    2 +-
>  9 files changed, 170 insertions(+), 297 deletions(-)
> 
> here's the commits:
> 
> - Collapse RISC-RAM retrieval code during a firmware-dump.
> - Wakeup DPC thread to process any deferred-work requests.
> - Correct ISP84XX verify-chip response handling.
> - Correct SRB usage-after-completion/free issues.
> - Re-register FDMI information after a LIP.
> - qla_os.c, make 2 functions static
> - make qla2x00_issue_iocb_timeout() static
> - Correct misc. endian and byte-ordering issues.
> - Correct regression in relogin code.
> - Update version number to 8.02.01-k2.

So, since I have to guess, I put my money on:

[PATCH 09/10] qla2xxx: Correct regression in relogin code

needs backporting to stable to fix the 2.6.24 regression bug 10486.

Do I win?

James


