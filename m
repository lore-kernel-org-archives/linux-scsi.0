From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 10/30] megaraid: add CERC_ATA100 support
Date: Fri, 10 Aug 2007 15:36:00 -0700
Message-ID: <20070810153600.7cd204b0.akpm@linux-foundation.org>
References: <200708102150.l7ALodH3011345@imap1.linux-foundation.org>
	<0631C836DBF79F42B5A60C8C8D4E8229BF18C7@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56725 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755771AbXHJWgO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 18:36:14 -0400
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229BF18C7@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Patro, Sumant" <Sumant.Patro@lsi.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, tkrah@fachschaft.imn.htwk-leipzig.de, protasnb@gmail.com, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>

On Fri, 10 Aug 2007 16:20:54 -0600
"Patro, Sumant" <Sumant.Patro@lsi.com> wrote:

> ID being added is already supported in megaraid_mbox driver.

umm, why should that cause us to avoid supporting it in the old driver?
