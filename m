From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Thu, 18 Aug 2005 16:06:03 -0400
Message-ID: <4304EA2B.6000107@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:58307 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932418AbVHRUGF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2005 16:06:05 -0400
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On 08/18/05 14:48, James.Smart@Emulex.Com wrote:
> 
> This is a heck of a statement... The customers don't see it as SAS vs FC
> vs SPI, they just see it as SCSI, and there's a lot of expectations on
> consistent behavior. We take a lot of heat defending the community's
> position, even from companies that you would have thought had signed on
> to the 2.6 behaviors.

I tried to understand this paragraph in the light of the very few past days,
but I couldn't.  What is it actually saying?

> I understand the need to push folks to the new 2.6 models, but I fully
> expect the same complaints to come from the users of SAS and iSCSI as well.

What kind of complaints?

I ask because I'm a "user of SAS and iSCSI".

> Please note that by implementing the consistent mappings, you are lessening
> the demands on the hba vendor to supply a non-upstream driver that works
> around the issue.

So LLDD would still have to do wild "scsi transport X domain" to "SPI Centric
HCIL used by SCSI Core" translation?  I'm not quite understanding.

>>What we might need an rport for is to support SMP.  I'm
>>not yet sure how to do SMP passthrough, but we will need some object
>>to represent SMP ports.
> 
> Depending on how SATA support is implemented, it may be useful for that.

Why do you need SMP ports?
Why and how are they going to be used for SATA?

Thanks,
	Luben
