From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC 10/n] HCIL drivers update
Date: Mon, 24 Oct 2005 04:15:13 -0400
Message-ID: <20051024081513.GA7160@havoc.gtf.org>
References: <20051023024104.GA20128@havoc.gtf.org> <20051023195128.GA12102@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:44160 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1750720AbVJXIPO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 04:15:14 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id C6FB51C0A7AF
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 04:15:13 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9O8FDZ7007241
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 04:15:13 -0400
Content-Disposition: inline
In-Reply-To: <20051023195128.GA12102@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Replace sdev_id(cmd->device) with scmd_id(cmd).

[patch too large for list, and is completely obvious]
