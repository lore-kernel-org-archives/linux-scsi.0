From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] scsi: netlink: avoid including netlink interface in
 scsi module
Date: Thu, 19 May 2011 10:48:09 -0700
Message-ID: <20110519104809.33057585.randy.dunlap@oracle.com>
References: <1305753940-18570-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:55029 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab1ESRsZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2011 13:48:25 -0400
In-Reply-To: <1305753940-18570-1-git-send-email-jengelh@medozas.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On Wed, 18 May 2011 23:25:39 +0200 Jan Engelhardt wrote:

> Only scsi_transport_fc needs it, so don't include it in scsi_mod
> if fc=m.
> 
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Many variations of SCSI=y/m, SCSI_NETLINK=y/m/n, PMCRAID=y/m/n,
SCSI_FC_ATTRS=y/m/n, SCSI_ISCSI_ATTRS=y/m/n build successfully for me.
(no run-time testing)


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
