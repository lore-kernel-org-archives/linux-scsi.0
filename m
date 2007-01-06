From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] megaraid: fix kernel-doc
Date: Fri, 5 Jan 2007 22:46:49 -0800
Message-ID: <20070105224649.6bc9ea26.randy.dunlap@oracle.com>
References: <20070105224148.c4bb945a.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:62098 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbXAFGqx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Jan 2007 01:46:53 -0500
In-Reply-To: <20070105224148.c4bb945a.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: Sumant.Patro@lsi.com, jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>

On Fri, 5 Jan 2007 22:41:48 -0800 Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>

Oh, this applies on top of today's patch from Sumant (which Andrew
has put into -mm)...


> kernel-doc modifications:
> - change "@param var" notation to @var;
> - change function/description separator from ':' to '-';
> - change var/description separator from '-' to ':';
> - fix a few doc. typos;
> - don't use kernel-doc /** lead-in when the doc. block is not kernel-doc;
> - use Linux common */ ending comment format instead of **/;
> - use correct function parameter names;
> - place function parameters immediately after the function short description;
> - place kernel-doc immediately before its function or macro;
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/scsi/megaraid/mega_common.h    |  120 ++++++-------
>  drivers/scsi/megaraid/megaraid_ioctl.h |   36 ++--
>  drivers/scsi/megaraid/megaraid_mbox.c  |  285 ++++++++++++++++-----------------
>  drivers/scsi/megaraid/megaraid_mbox.h  |   42 ++--
>  drivers/scsi/megaraid/megaraid_mm.c    |   65 +++----
>  drivers/scsi/megaraid/megaraid_sas.h   |   14 -
>  6 files changed, 275 insertions(+), 287 deletions(-)


---
~Randy
