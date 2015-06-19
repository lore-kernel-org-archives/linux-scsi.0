From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/8] tcm_loop updates
Date: Fri, 19 Jun 2015 08:48:55 +0200
Message-ID: <20150619064855.GB1183@lst.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59550 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbbFSGs5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 02:48:57 -0400
Content-Disposition: inline
In-Reply-To: <1434620622-65391-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>

What's the benefit of the SAS transport class writeout?  I honestly
always saw tcm_loop as a simple loopback driver, with the different
transport IDs in the PR code as a gimmick.  Note that vhost and
xen-blkback copies that style and I did plan to consolidate it
in common code.
