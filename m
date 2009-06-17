From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] SCSI: explain the hidden scsi_wait_scan Kconfig variable
Date: Wed, 17 Jun 2009 12:28:03 +0200
Message-ID: <4A38C533.3070106@s5r6.in-berlin.de>
References: <4A384FE4.9090703@gmail.com> <20090617021254.GQ19977@parisc-linux.org> <tkrat.ad6f8fb712020451@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:56654 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764195AbZFQK2F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2009 06:28:05 -0400
In-Reply-To: <tkrat.ad6f8fb712020451@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Changli Gao <xiaosuo@gmail.com>, James.Bottomley@HansenPartnership.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Stefan Richter wrote:
> People keep sending patches to expose CONFIG_SCSI_WAIT_SCAN as a tunable
> item.  These patches aren't accepted upstream, so let's stop the ongoing
> irritation of people due to this obscure and strange installed module
> and its Kconfig option.

PS, references:
http://bugzilla.kernel.org/show_bug.cgi?id=8763
http://bugzilla.kernel.org/show_bug.cgi?id=8872
http://bugzilla.kernel.org/show_bug.cgi?id=9769
and more mailinglist references than you can shake a stick at, yet 
nobody is aware of.
-- 
Stefan Richter
-=====-==--= -==- =---=
http://arcgraph.de/sr/
