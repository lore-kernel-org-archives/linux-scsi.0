From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RESEND v2 3/18] megaraid_sas : Add separate functions for
 building sysPD IOs and non RW LDIOs
Date: Tue, 21 Apr 2015 03:44:17 -0700
Message-ID: <20150421104417.GD8920@infradead.org>
References: <201504201423.t3KENi0P010881@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45794 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbbDUKoS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2015 06:44:18 -0400
Content-Disposition: inline
In-Reply-To: <201504201423.t3KENi0P010881@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

Looks generally good, but the MEGASAS_DEV_INDEX prototype change
should be a patch on it's own.
