From: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Subject: Re: [PATCH v2][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Tue, 11 Dec 2012 13:46:56 +0100
Message-ID: <1355230016.20256.6.camel@br8ggx07.de.ibm.com>
References: <1355214219-17343-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:51676 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2LKMrF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Dec 2012 07:47:05 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mpeschke@linux.vnet.ibm.com>;
	Tue, 11 Dec 2012 05:47:04 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id B8ED63E4003F
	for <linux-scsi@vger.kernel.org>; Tue, 11 Dec 2012 05:46:58 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id qBBCl14k302624
	for <linux-scsi@vger.kernel.org>; Tue, 11 Dec 2012 05:47:01 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id qBBCl1XK013939
	for <linux-scsi@vger.kernel.org>; Tue, 11 Dec 2012 05:47:01 -0700
In-Reply-To: <1355214219-17343-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

Hello Hannes,

> fc_eh_it_nexus_loss_handler() is invoked as the
> eh_target_reset_handler() callback and the
> eh_bus_reset_handler() is removed.

lpfc_target_reset_handler(), which is replaced by your patch, used to
issue a TARGET_RESET task management function over FCP in the
eh_target_reset_handler() callback. What's wrong with that?

Martin


