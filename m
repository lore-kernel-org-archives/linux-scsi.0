From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: merge release_cmd methods
Date: Fri, 03 Jun 2011 18:28:55 -0700
Message-ID: <1307150935.8419.5.camel@haakon2.linux-iscsi.org>
References: <20110601015718.GA28574@infradead.org>
	 <20110601035657.GA17204@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38720 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1FDBhb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2011 21:37:31 -0400
In-Reply-To: <20110601035657.GA17204@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Tue, 2011-05-31 at 23:56 -0400, Christoph Hellwig wrote:
> [add the missing lists]
> 
> On Tue, May 31, 2011 at 09:57:18PM -0400, Christoph Hellwig wrote:
> The release_cmd_to_pool and release_cmd_direct methods are always the same.
> Merge them into a single release_cmd method, and clean up the fallout.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Hey Christoph,

Apologies for the delay here..  I think this looks reasonable to merge
into for v4.1, and thanks for the nice target core and fabric cleanup
with TFO->release_cmd().

Committed as e6ce6902ad2 into lio-core-2.6.git/master with some minor
transport_generic_free_cmd() parameter build breakage in
drivers/target/tcm_fc/tfc_cmd.c.

--nab


