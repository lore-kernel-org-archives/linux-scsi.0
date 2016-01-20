From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH] lpfc: Remove redundant code block in
 lpfc_scsi_cmd_iocb_cmpl
Date: Wed, 20 Jan 2016 22:52:55 +0100
Message-ID: <20160120225255.00000544@localhost>
References: <1453302520-10499-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60866 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbcATVx1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 16:53:27 -0500
In-Reply-To: <1453302520-10499-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

Johannes Thumshirn wrote:
> This removes a redundant code block that will either be executed if the
> ENABLE_FCP_RING_POLLING flag is set in phba->cfg_poll or not. The code is just
> duplicated in both cases, hence we unify it again.
> 
> This probably is a left over from some sort of refactoring.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Reviewed-by: Sebastian Herbszt <herbszt@gmx.de>
