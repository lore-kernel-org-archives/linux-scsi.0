From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/5] trivial target cleanups
Date: Tue, 31 May 2011 17:51:11 -0700
Message-ID: <1306889471.8193.389.camel@haakon2.linux-iscsi.org>
References: <20110531210641.032149131@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45679 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab1FAA7f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2011 20:59:35 -0400
In-Reply-To: <20110531210641.032149131@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Hi Christoph,

Thanks for these cleanups, and for tfo->new_cmd_failure() removal w/
tcm_mode_builder.py changes in patch #1.

Committed and pushed into lio-core-2.6.git/master.

--nab


