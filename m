From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/7] iscsi-target: Handle transport_generic_new_cmd
	failure
Date: Sat, 4 Jun 2011 16:00:36 +0200
Message-ID: <20110604140036.GA13359@lst.de>
References: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org> <1307150298-23921-5-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57238 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756407Ab1FDOAh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Jun 2011 10:00:37 -0400
Content-Disposition: inline
In-Reply-To: <1307150298-23921-5-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Jun 03, 2011 at 06:18:15PM -0700, Nicholas A. Bellinger wrote:
> +	ret = transport_generic_new_cmd(&cmd->se_cmd);
> +	if ((ret < 0) || (SE_CMD(cmd)->se_cmd_flags & SCF_SE_CMD_FAILED)) {

No need for the inner braces.  Also SCF_SE_CMD_FAILED won't ever be
set if you call transport_generic_new_cmd, so no need to check it.

