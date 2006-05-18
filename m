From: Tejun Heo <htejun@gmail.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Thu, 18 May 2006 12:27:48 +0900
Message-ID: <446BE9B4.60605@gmail.com>
References: <4468B596.9090508@garzik.org>	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>	 <4469F2B2.703@garzik.org>	 <1147794708.3505.30.camel@mulgrave.il.steeleye.com>	 <4469F906.7040602@gmail.com>	 <1147796999.3505.42.camel@mulgrave.il.steeleye.com>	 <446A0053.5070203@gmail.com>	 <1147798226.3505.56.camel@mulgrave.il.steeleye.com>	 <446A06C7.5050609@gmail.com>  <20060516195836.GA3807@infradead.org> <1147814935.3505.88.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:19880 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1751138AbWERD15 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 23:27:57 -0400
Received: by nf-out-0910.google.com with SMTP id d4so280195nfe
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2006 20:27:56 -0700 (PDT)
In-Reply-To: <1147814935.3505.88.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

James Bottomley wrote:
> On Tue, 2006-05-16 at 20:58 +0100, Christoph Hellwig wrote:
>> Things used by the transport classes traditionally weren't in scsi_priv.h,
>> that was for scsi_mod internals only.  Should we changed that?  I'd rather
>> have another header for semi-volatile APIs transport classes use.
> 
> well ... OK we don't necessarily have a header for SCSI APIs exported
> exclusively to transport classes.  how about
> drivers/scsi/scsi_transport_api.h?
> 

Are we agreed on this?  A new header file drivers/scsi/scsi_transport_api.h?

-- 
tejun
