From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi_debug issues
Date: Sat, 16 Oct 2004 11:50:18 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041016105018.GA30336@infradead.org>
References: <20041015190154.GA3073@us.ibm.com> <4170C505.3000805@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:3079 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268582AbUJPKuZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Oct 2004 06:50:25 -0400
Content-Disposition: inline
In-Reply-To: <4170C505.3000805@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, linux-scsi@vger.kernel.org

A dma address is not a physical address.  You need to kmap the virtual
addresses in the sg lists to get a kernel virtual address. 
