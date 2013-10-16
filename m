From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 01/11] target core: rename (ex,im)plict -> (ex,im)plicit
Date: Wed, 16 Oct 2013 14:13:20 -0700
Message-ID: <1381958000.19256.643.camel@haakon3.risingtidesystems.com>
References: <1381908048-82014-1-git-send-email-hare@suse.de>
	 <1381908048-82014-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48127 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761409Ab3JPVEe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2013 17:04:34 -0400
In-Reply-To: <1381908048-82014-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2013-10-16 at 09:20 +0200, Hannes Reinecke wrote:
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_alua.c      | 110 ++++++++++++++++-----------------
>  drivers/target/target_core_alua.h      |  20 +++---
>  drivers/target/target_core_configfs.c  |  26 ++++----
>  drivers/target/target_core_device.c    |   6 +-
>  drivers/target/target_core_file.c      |   2 +-
>  drivers/target/target_core_pr.c        |  24 +++----
>  drivers/target/target_core_spc.c       |   6 +-
>  drivers/target/target_core_transport.c |   4 +-
>  drivers/target/target_core_ua.h        |   2 +-
>  include/target/target_core_base.h      |   2 +-
>  10 files changed, 101 insertions(+), 101 deletions(-)
> 

Applied to target-pending/for-next.

Thanks Hannes!

--nab

