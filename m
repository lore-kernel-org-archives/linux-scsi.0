From: Arne Redlich <arne.redlich@xiranet.com>
Subject: Re: [PATCH] srp.h: avoid padding of structs
Date: Tue, 18 Apr 2006 18:27:42 +0200
Message-ID: <1145377662.8447.2.camel@confield.dd.xiranet.com>
References: <20060416193443.GA1806@cheetah> <20060417091752.GA2947@cheetah>
	 <adavet6j2cs.fsf_-_@cisco.com>
Reply-To: arne.redlich@xiranet.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 162.237.80.212.versanetonline.de ([212.80.237.162]:11999 "EHLO
	cheetah.dd.xiranet.com") by vger.kernel.org with ESMTP
	id S1750750AbWDRQ2E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Apr 2006 12:28:04 -0400
In-Reply-To: <adavet6j2cs.fsf_-_@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Am Dienstag, den 18.04.2006, 09:05 -0700 schrieb Roland Dreier:
> Thanks for pointing out this problem.  However I don't think we should
> pack every structure in the file, because packing structures that
> don't need it leads to gcc generating horrible code on architectures
> like ia64.  I'd prefer something like the following.

Sure - I wasn't aware that gcc will produce different code even if it
doesn't have to insert padding bytes.

Thanks,
Arne
-- 
Arne Redlich
Xiranet Communications GmbH

