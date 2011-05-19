From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] scsi: netlink: avoid including netlink interface in
 scsi module
Date: Wed, 18 May 2011 17:48:57 -0700
Message-ID: <20110518174857.77dbda09.randy.dunlap@oracle.com>
References: <1305753940-18570-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:34647 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1ESAtO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2011 20:49:14 -0400
In-Reply-To: <1305753940-18570-1-git-send-email-jengelh@medozas.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On Wed, 18 May 2011 23:25:39 +0200 Jan Engelhardt wrote:

> Only scsi_transport_fc needs it, so don't include it in scsi_mod
> if fc=m.

BTW, scsi_transport_iscsi.c also makes netlink calls (but it's missing the
needed header files).

and what about pmcraid.c ?

> Cc: Randy Dunlap <randy.dunlap@oracle.com>   // was not cc:ed
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  drivers/scsi/Kconfig        |    3 ++-
>  drivers/scsi/Makefile       |    2 +-
>  drivers/scsi/scsi.c         |    3 ---
>  drivers/scsi/scsi_netlink.c |   22 +++++++++++++---------
>  drivers/scsi/scsi_priv.h    |    7 +------
>  5 files changed, 17 insertions(+), 20 deletions(-)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
