From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH]: megaraid 2.20.4: Fixes a data corruption bug
Date: 05 Oct 2004 14:27:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097004463.2064.85.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E570230C98F@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:30096 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263540AbUJET1u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2004 15:27:50 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230C98F@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: "Mukker, Atul" <Atulm@lsil.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, 'Andrew Morton' <akpm@osdl.org>, "'Matt_Domsch@dell.com'" <Matt_Domsch@dell.com>, "Ju, Seokmann" <sju@lsil.com>

On Tue, 2004-10-05 at 14:15, Bagalkote, Sreenivas wrote:
> The latest megaraid driver on bk://linux-scsi.bkbits.net/scsi-misc-2.6 still
> has
> CONFIG_COMPAT around register_ioctl32_conversion. Will it remain in the
> source
> or should it go?

I'd like to see a patch taking it out, please.

James


