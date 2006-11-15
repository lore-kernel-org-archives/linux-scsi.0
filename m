From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: Re: [PATCH] [SCSI] qla4xxx: add support for qla4032
Date: Wed, 15 Nov 2006 11:03:00 -0800
Message-ID: <1163617380.3916.0.camel@dcslnxpc.site>
References: <1163209850.4485.14.camel@dcslnxpc.site>
	 <455A5E06.5000200@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47516 "EHLO
	avexch1.qlogic.com") by vger.kernel.org with ESMTP id S1030882AbWKOTDA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Nov 2006 14:03:00 -0500
In-Reply-To: <455A5E06.5000200@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, David Wagner <david.wagner@qlogic.com>

On Tue, 2006-11-14 at 18:23 -0600, Mike Christie wrote:
> David C Somayajulu wrote:
> > The following patch provides the following:
> > 
> > 1. adds support for the next version of Qlogic's iSCSI HBA, qla4032 (PCI Device ID 4032). 
> > 2. removes dead code related to topcat chip and renames qla4010_soft_reset to qla4xxx_soft_reset (minor changes).
> > 
> > 
> 
> This patch adds some trailing whitespaces.
> 
> Adds trailing whitespace.
> .dotest/patch:47:#endif
> Adds trailing whitespace.
> .dotest/patch:51:#endif

> Could you clean that up?
Will fix and repost.
> 
> Also this patch applied with fuzz. Was it made against the current
> upstream qla4xxx code or is this from another kernel?
I generated it against scsi-misc.
