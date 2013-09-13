From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 1/5] drivers/scsi/a100u2w.c: convert to module_pci_driver
Date: Fri, 13 Sep 2013 15:14:35 -0700
Message-ID: <1379110475.2198.52.camel@dabdike.int.hansenpartnership.com>
References: <20130913215226.831285A427E@corp2gmr1-2.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55996 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754860Ab3IMWOh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Sep 2013 18:14:37 -0400
In-Reply-To: <20130913215226.831285A427E@corp2gmr1-2.hot.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, clbchenlibo.chen@huawei.com

On Fri, 2013-09-13 at 14:52 -0700, akpm@linux-foundation.org wrote:
> From: Libo Chen <clbchenlibo.chen@huawei.com>
> Subject: drivers/scsi/a100u2w.c: convert to module_pci_driver
> 
> Use module_pci_driver instead of init/exit, make code clean.

To be honest, I don't really agree that any of these patches add value.
Sure, for new drivers we should be using module_pci_driver, but for
existing ones it's just pointless churn.

That said, if the maintainers want this, I'll take it.  That means we
don't do this for the unmaintained drivers (dmx3191d, a100u2w) but we
might for the others.

James


