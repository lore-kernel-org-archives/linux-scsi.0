From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 0/9] scsi_data_buffer structure (in preparation for
 bidi)
Date: Fri, 7 Sep 2007 06:52:58 +0900
Message-ID: <20070906184615W.tomof@acm.org>
References: <20070906183448I.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:60960 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507AbXIFWAc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2007 18:00:32 -0400
In-Reply-To: <20070906183448I.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, James.Bottomley@SteelEye.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp

On Fri, 7 Sep 2007 06:50:08 +0900
FUJITA Tomonori <tomof@acm.org> wrote:

> This patchset, which I submitted before, adds a new data structure,
> scsi_data_buffer, including everything for data transfer:

This patch is against Jens' sglist branch with the following patches:

http://marc.info/?l=linux-scsi&m=118881570332241&w=2

http://marc.info/?l=linux-scsi&m=118908296515488&w=2
