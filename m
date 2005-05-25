From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2.6.12-rc4-mm1 3/4] megaraid_sas: updating the driver
Date: Wed, 25 May 2005 06:49:14 +0100
Message-ID: <20050525054914.GA8574@infradead.org>
References: <60807403EABEB443939A5A7AA8A7458B01399B22@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41384 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263195AbVEYFtT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 01:49:19 -0400
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B01399B22@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Arjan van de Ven <arjan@infradead.org>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Matt_Domsch@Dell.com, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>

On Tue, May 24, 2005 at 04:45:05PM -0400, Salyzyn, Mark wrote:
> Could I get an historical (2.4 & Distribution) perspective on this. At
> which point, or what code/include/manifest/version delineating it, would
> you say the driver is no longer, if ever, required to place a lock
> (host_lock or io_request_lock) around the scsi_done call?
> 
> I expect (or hope) the answer to be: always needs io_request_lock in
> 2.4, never needed the host_lock in 2.5+.

You don't need any lock in 2.4 either.

