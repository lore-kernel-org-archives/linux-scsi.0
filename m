From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 05/10] libata: separate ATAPI code
Date: Mon, 12 Nov 2012 10:57:10 -0800
Message-ID: <20121112185710.GD5560@mtj.dyndns.org>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
 <1352443922-13734-6-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:49077 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab2KLS5P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Nov 2012 13:57:15 -0500
Content-Disposition: inline
In-Reply-To: <1352443922-13734-6-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On Fri, Nov 09, 2012 at 02:51:57PM +0800, Aaron Lu wrote:
> The atapi_eh_tur and atapi_eh_request_sense can be reused by ZPODD
> code, so separate them out to a file named libata-atapi.c, and the
> Makefile is modified accordingly. No functional changes should result
> from this commit.

Why is this change necessary?  This doesn't seem to help anything to
me.

Thanks.

-- 
tejun
