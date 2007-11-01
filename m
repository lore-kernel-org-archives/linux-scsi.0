From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 3/3] debloat aic7xxx and aic79xx drivers
Date: Thu, 1 Nov 2007 15:23:28 -0700
Message-ID: <20071101152328.be2a4515.randy.dunlap@oracle.com>
References: <200710141558.27156.vda.linux@googlemail.com>
	<200710141600.10468.vda.linux@googlemail.com>
	<200710141601.08946.vda.linux@googlemail.com>
	<200710141602.16283.vda.linux@googlemail.com>
	<20071101221604.GB19914@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:53494 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbXKAWZY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Nov 2007 18:25:24 -0400
In-Reply-To: <20071101221604.GB19914@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007 16:16:04 -0600 Matthew Wilcox wrote:

> On Sun, Oct 14, 2007 at 04:02:15PM +0100, Denys Vlasenko wrote:
> > Adds more consts
> 
> error: patch failed: drivers/scsi/aic7xxx/aic79xx.h:1328
> error: drivers/scsi/aic7xxx/aic79xx.h: patch does not apply
> error: patch failed: drivers/scsi/aic7xxx/aic7xxx.h:1145
> error: drivers/scsi/aic7xxx/aic7xxx.h: patch does not apply

when attempting to apply to scsi-misc or linus-git or ... ?

Thanks,
---
~Randy
