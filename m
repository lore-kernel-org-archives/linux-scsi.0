From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 09/13] lpfc: Add embedded data pointers for enhanced
 performance
Date: Wed, 7 Feb 2018 11:17:32 +0100
Message-ID: <20180207101732.t6q5tagc2wqegax4@linux-x5ow.site>
References: <20180207022851.11800-1-jsmart2021@gmail.com>
 <20180207022851.11800-10-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53388 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753376AbeBGKRd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Feb 2018 05:17:33 -0500
Content-Disposition: inline
In-Reply-To: <20180207022851.11800-10-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Tue, Feb 06, 2018 at 06:28:47PM -0800, James Smart wrote:
> +		if (do_pbde && (i == 0)) {
Nit: 
		if (do_pde && i == 0) {

Else:

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
