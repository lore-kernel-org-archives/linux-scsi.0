From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] scsi_forget_host - scsi_debug usage
Date: Mon, 14 Jun 2004 09:06:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040614080632.GA7114@infradead.org>
References: <20040612041930.GA21105@us.ibm.com> <20040612042106.GB21105@us.ibm.com> <20040612042232.GC21105@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:11985 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261981AbUFNIGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2004 04:06:32 -0400
Received: from hch by pentafluge.infradead.org with local (Exim 4.33 #1 (Red Hat Linux))
	id 1BZmUC-0001rT-5T
	for linux-scsi@vger.kernel.org; Mon, 14 Jun 2004 09:06:32 +0100
Content-Disposition: inline
In-Reply-To: <20040612042232.GC21105@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Fri, Jun 11, 2004 at 09:22:32PM -0700, Mike Anderson wrote:
> DESC
> scsi_forget_host - scsi_debug usage
> 
> Use the export scsi_forget_host interface to remove child scsi devices
> from the scsi_host prior to removal.

Moving this into drivers sounds like a rather bad idea.  But with our
refcounting in place I wonder whether moving scsi_forget_host first in
scsi_remove_host wouldn't simply work.

