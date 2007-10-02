From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 01/17] git-scsi-misc: arcmsr build fix
Date: Tue, 02 Oct 2007 17:03:51 -0500
Message-ID: <1191362631.3530.141.camel@localhost.localdomain>
References: <200710022137.l92LbxEw023552@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:54327 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754143AbXJBWDx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 18:03:53 -0400
In-Reply-To: <200710022137.l92LbxEw023552@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org

On Tue, 2007-10-02 at 14:37 -0700, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> drivers/scsi/arcmsr/arcmsr_hba.c:129: error: 'arcmsr_pci_error_detected' undeclared here (not in a function)
> drivers/scsi/arcmsr/arcmsr_hba.c:130: error: 'arcmsr_pci_slot_reset' undeclared here (not in a function)
> 
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Heh, snap:

http://marc.info/?l=linux-scsi&m=119081791117423&w=2

James


