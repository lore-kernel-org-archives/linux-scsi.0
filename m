From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] target_core_alua: check for buffer overflow
Date: Thu, 19 Dec 2013 13:43:53 -0800
Message-ID: <1387489433.5567.53.camel@haakon3.risingtidesystems.com>
References: <1387460172-27396-1-git-send-email-hare@suse.de>
	 <1387460172-27396-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51292 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab3LSVmw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2013 16:42:52 -0500
In-Reply-To: <1387460172-27396-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 2013-12-19 at 14:36 +0100, Hannes Reinecke wrote:
> When a writing to a command-provided buffer we need to ensure
> that we're not writing past the end of it.
> At the same time we need to continue processing as typically
> the final data length (ie the required size of the buffer)
> need to be returned.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_alua.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 

Applied.  Thanks Hannes!

--nab


