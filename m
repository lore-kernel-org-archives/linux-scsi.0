From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] SCSI: explain the hidden scsi_wait_scan Kconfig variable
Date: Thu, 18 Jun 2009 08:57:25 +0800
Message-ID: <412e6f7f0906171757x673ad9d2u2e116161cba550a0@mail.gmail.com>
References: <4A384FE4.9090703@gmail.com>
	 <20090617021254.GQ19977@parisc-linux.org>
	 <tkrat.ad6f8fb712020451@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:50235 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbZFRA5X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2009 20:57:23 -0400
In-Reply-To: <tkrat.ad6f8fb712020451@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Matthew Wilcox <matthew@wil.cx>, James.Bottomley@hansenpartnership.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wed, Jun 17, 2009 at 6:07 PM, Stefan
Richter<stefanr@s5r6.in-berlin.de> wrote:
> People keep sending patches to expose CONFIG_SCSI_WAIT_SCAN as a tunable
> item.  These patches aren't accepted upstream, so let's stop the ongoing
> irritation of people due to this obscure and strange installed module
> and its Kconfig option.
Aha, I really like this, and think it works. :)


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
