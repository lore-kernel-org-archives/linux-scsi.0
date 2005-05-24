From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: [PATCH 2.6.12-rc4-mm1 3/4] megaraid_sas: updating the driver
Date: Tue, 24 May 2005 23:16:49 +0200
Message-ID: <1116969409.6280.42.camel@laptopd505.fenrus.org>
References: <60807403EABEB443939A5A7AA8A7458B01399B22@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33693 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262192AbVEXVRF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 17:17:05 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B01399B22@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Bagalkote, Sreenivas" <sreenib@lsil.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Matt_Domsch@Dell.com, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>


> I expect (or hope) the answer to be: always needs io_request_lock in
> 2.4, never needed the host_lock in 2.5+.

afaik in RHEL3 you don't need it either but are allowed to.


