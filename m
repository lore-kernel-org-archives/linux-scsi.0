From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/4] tcm: Convert to use enum dma_data_direction
Date: Thu, 16 Sep 2010 12:06:51 +0900
Message-ID: <20100916120651X.fujita.tomonori@lab.ntt.co.jp>
References: <1284496031-13460-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:63190 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab0IPDqc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2010 23:46:32 -0400
In-Reply-To: <1284496031-13460-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: bharrosh@panasas.com, konrad@darnok.org, fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, hare@suse.de, James.Bottomley@suse.de, linux-iscsi-target-dev@googlegroups.com, linux-scsi@vger.kernel.org

On Tue, 14 Sep 2010 13:27:11 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> Attached is a series to convert the TCM Core, TCM_Loop, TCM_FC and LIO-Target
> fabric modules to use the modern values include/linux/dma-mapping.h:
> enum dma_data_direction for signaling CDB data direction.

Some drivers don't do DMA so I'm not sure that using enum
dma_data_direction as a generic direction type is correct. But we
already do everywhere (e.g. sc_data_direction in struct scsi_cmnd), so
at least using dma_data_direction looks better than defining the own
direction type.
