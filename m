From: Ricky Beam <jfbeam@bluetronic.net>
Subject: Re: dpt_i2o in 2.6.0_test*
Date: Mon, 11 Aug 2003 14:44:32 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0308111442040.7750-100000@sweetums.bluetronic.net>
References: <20030809211706.A1938@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sweetums.bluetronic.net ([24.199.150.42]:39553 "EHLO
	sweetums.bluetronic.net") by vger.kernel.org with ESMTP
	id S272919AbTHKSqj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 14:46:39 -0400
In-Reply-To: <20030809211706.A1938@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Alexandru N. Barloiu" <slak@dale.ro>, linux-scsi@vger.kernel.org

On Sat, 9 Aug 2003, Christoph Hellwig wrote:
>According to Alan the fix is to use the i2o_scsi driver instead.

Doing so removes support for DPT's RAID management software.

Start screaming at Adaptec to update their stinking driver!

--Ricky


