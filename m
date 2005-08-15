From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Mon, 15 Aug 2005 11:04:52 -0400
Message-ID: <4300AF14.3070508@adaptec.com>
References: <20050815135537.GB19426@lst.de> <1124116522.3228.42.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:14023 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964792AbVHOPFC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 11:05:02 -0400
In-Reply-To: <1124116522.3228.42.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, andrew.patterson@hp.com, Eric.Moore@lsil.com, ltuikov@yahoo.com, jejb@steeleye.com

On 08/15/05 10:35, Arjan van de Ven wrote:
> On Mon, 2005-08-15 at 15:55 +0200, Christoph Hellwig wrote:
> 
>>+EXPORT_SYMBOL(sas_add_target);
> 
> 
> should these exports be _GPL? After all they're very much linux specific
> functionality...

Someone needs this for a binary only driver? ;-)

	Luben
