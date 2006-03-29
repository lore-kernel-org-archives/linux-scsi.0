From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 05/10] ipr: Disk remove path cleanup
Date: Wed, 29 Mar 2006 09:18:14 -0600
Message-ID: <442AA536.5040901@us.ibm.com>
References: <200603291438.k2TEcJj0006799@d01av02.pok.ibm.com> <20060329151000.GB14690@infradead.org>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49610 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751164AbWC2PSa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 10:18:30 -0500
In-Reply-To: <20060329151000.GB14690@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

Christoph Hellwig wrote:
> On Wed, Mar 29, 2006 at 08:38:18AM -0600, Brian King wrote:
>> Instead of NULLing the resource entry pointer when a disk
>> goes away to prevent any new commands being sent to it,
>> set the adapter resource handle to an invalid value so
>> new ops getting sent to it will fail with a selection timeout
>> response. This patch is needed for future SATA patches.
> 
> It would help greatly if you could split out the patches that don't
> require libata changes so they could go into scsi-misc already.

Ok. Will do.

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
