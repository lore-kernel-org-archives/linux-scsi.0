From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [Patch] QLogic qla2x00 driver fixes
Date: Fri, 25 Feb 2005 12:09:20 -0500
Message-ID: <421F5BC0.50809@adaptec.com>
References: <1109305293.27139.216.camel@compaq-rhel4.xsintricity.com>	 <1109318231.6290.27.camel@laptopd505.fenrus.org>	 <421EE410.7020603@pobox.com> <1109332659.27139.224.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:24458 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262753AbVBYRJ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 12:09:26 -0500
In-Reply-To: <1109332659.27139.224.camel@compaq-rhel4.xsintricity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Arjan van de Ven <arjan@infradead.org>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On 02/25/05 06:57, Doug Ledford wrote:
> struct is silly.  Just use what's available, reliable, always
> initialized, and intended for you to use (cmd->use_sg) instead of trying
> to use a roughly duplicate item from a different abstraction layer that
> isn't always involved in commands sent to a low level driver (request-

Yes, I agree.

	Luben

