From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] [SCSI] qla4xxx: add support for qla4032
Date: Tue, 14 Nov 2006 18:23:34 -0600
Message-ID: <455A5E06.5000200@cs.wisc.edu>
References: <1163209850.4485.14.camel@dcslnxpc.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39889 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S966525AbWKOAXt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Nov 2006 19:23:49 -0500
In-Reply-To: <1163209850.4485.14.camel@dcslnxpc.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, David Wagner <david.wagner@qlogic.com>

David C Somayajulu wrote:
> The following patch provides the following:
> 
> 1. adds support for the next version of Qlogic's iSCSI HBA, qla4032 (PCI Device ID 4032). 
> 2. removes dead code related to topcat chip and renames qla4010_soft_reset to qla4xxx_soft_reset (minor changes).
> 
> 

This patch adds some trailing whitespaces.

Adds trailing whitespace.
.dotest/patch:47:#endif
Adds trailing whitespace.
.dotest/patch:51:#endif

Could you clean that up?

Also this patch applied with fuzz. Was it made against the current
upstream qla4xxx code or is this from another kernel?
