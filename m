From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Patch] QLogic qla2x00 driver fixes
Date: Fri, 25 Feb 2005 08:57:10 +0100
Message-ID: <1109318231.6290.27.camel@laptopd505.fenrus.org>
References: <1109305293.27139.216.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:9390 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262646AbVBYH5Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 02:57:16 -0500
In-Reply-To: <1109305293.27139.216.camel@compaq-rhel4.xsintricity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Thu, 2005-02-24 at 23:21 -0500, Doug Ledford wrote:
> Don't use cmd->request->nr_hw_segments as it may not be initialized
> (SG_IO in particular bypasses anything that initializes this and just
> uses scsi_do_req to insert a scsi_request directly on the head of the
> queue) 

should we fix that in the SG_IO layer ?


