From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/2] be2iscsi : Revert ownership and update MAINTAINER
Date: Tue, 06 Oct 2015 10:43:39 -0500
Message-ID: <5613EC2B.30208@cs.wisc.edu>
References: <1435963328-29071-1-git-send-email-ketan.mukadam@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41745 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbbJFPnr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Oct 2015 11:43:47 -0400
In-Reply-To: <1435963328-29071-1-git-send-email-ketan.mukadam@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ketan Mukadam <ketan.mukadam@avagotech.com>, linux-scsi@vger.kernel.org

On 07/03/2015 05:42 PM, Ketan Mukadam wrote:
> Revert the ownership to Emulex and update the MAINTAINER for be2iscsi
> 
> Ketan Mukadam (2):
>   MAINTAINERS: Update MAINTAINER list
>   be2iscsi: Revert ownership to Emulex
> 
>  MAINTAINERS                      | 4 ++--
>  drivers/scsi/be2iscsi/Kconfig    | 4 ++--
>  drivers/scsi/be2iscsi/Makefile   | 2 +-
>  drivers/scsi/be2iscsi/be.h       | 4 ++--
>  drivers/scsi/be2iscsi/be_cmds.c  | 4 ++--
>  drivers/scsi/be2iscsi/be_cmds.h  | 4 ++--
>  drivers/scsi/be2iscsi/be_iscsi.c | 4 ++--
>  drivers/scsi/be2iscsi/be_main.c  | 8 ++++----
>  drivers/scsi/be2iscsi/be_main.h  | 6 +++---
>  drivers/scsi/be2iscsi/be_mgmt.c  | 4 ++--
>  drivers/scsi/be2iscsi/be_mgmt.h  | 4 ++--
>  11 files changed, 24 insertions(+), 24 deletions(-)
> 

Patches look fine to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
