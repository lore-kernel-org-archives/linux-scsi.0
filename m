From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH 2.6.12-rc4-mm1 1/4] megaraid_sas: updating the driver
Date: Mon, 16 May 2005 15:56:07 +0100
Message-ID: <20050516145607.GC25156@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57060CCE7A@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:4015 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261670AbVEPO4N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 10:56:13 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57060CCE7A@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>, 'Christoph Hellwig' <hch@infradead.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>

On Mon, May 16, 2005 at 02:51:22AM -0400, Bagalkote, Sreenivas wrote:
> Hello All,
> 
> Please review this update to the previously submitted megaraid_sas driver.
> I have adopted all the feedback received for the initial submission. Since
> most of the code is rearranged, I have split the patches into four parts - 
> the first two remove the original code and the second two add the new code.

As your driver is not in the scsi tree yet please send diff in future that
just apply against the scsi-misc tree.  Also please use a mailer that
doesn't mangle the patches.

