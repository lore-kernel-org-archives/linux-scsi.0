From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 01/16] scsi_dh_alua: Improve error handling
Date: Fri, 14 Feb 2014 12:16:09 +0100
Message-ID: <52FDFAF9.3040409@acm.org>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:40759 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752101AbaBNLQZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Feb 2014 06:16:25 -0500
In-Reply-To: <1391160600-19652-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 01/31/14 10:29, Hannes Reinecke wrote:
> - * alua_stpg - Evaluate SET TARGET GROUP STATES
> + * stpg_endio - Evaluate SET TARGET GROUP STATES

Great that you are fixing the function header of stpg_endio(). But
please consider to use here the official terminology from SPC ("SET
TARGET PORT GROUPS").

Bart.

