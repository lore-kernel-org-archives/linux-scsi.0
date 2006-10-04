From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] [PATCH] qla4xxx driver resubmission
Date: Wed, 4 Oct 2006 10:44:41 -0600
Message-ID: <20061004164441.GF28596@parisc-linux.org>
References: <1159976986.3437.12.camel@mulgrave.il.steeleye.com> <0BB3E5E7462EEA4295BC02D49691DC074A403C@AVEXCH1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54216 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1161582AbWJDQom (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Oct 2006 12:44:42 -0400
Content-Disposition: inline
In-Reply-To: <0BB3E5E7462EEA4295BC02D49691DC074A403C@AVEXCH1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Somayajulu <david.somayajulu@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, David Wagner <david.wagner@qlogic.com>

On Wed, Oct 04, 2006 at 09:30:07AM -0700, David Somayajulu wrote:
> Thanks a lot James. My apologies for the inconvenience pertaining to
> whitespaces. For future, is there any tool out there which one run, to
> sanitize the code before submission.

grep -n ' \t' drivers/scsi/ncr53c8xx.c

