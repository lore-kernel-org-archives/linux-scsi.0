From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: st.c page_to_pfn() usage
Date: Sun, 24 Oct 2004 01:40:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098574847.7207.10.camel@laptop.fenrus.com>
References: <20041023113547.GD5855@fenrus.demon.nl>
	 <Pine.LNX.4.61.0410232255030.6707@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:31760 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S261241AbUJWXlC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Oct 2004 19:41:02 -0400
In-Reply-To: <Pine.LNX.4.61.0410232255030.6707@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: William Lee Irwin III <wli@holomorphy.com>, linux-scsi@vger.kernel.org


> The code is inside DEB(), i.e., it is debugging code. The purpose of the 
> code is to count the occasions where physically contiguous pages could be 
> combined to a single scatter/gather segment. No decisions are made based 
> on the result. My experiments suggested that combining is not usually 
> possible and it is not worth trying. I did not rip off the code in case it 
> would prove useful later. If it is incorrect, the easiest solution is to 
> rip off everything related to STp->nbr_combinable.

just ignore my email; as william points out I'm flat out wrong....
-- 

