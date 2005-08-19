From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 19 Aug 2005 15:08:39 -0400
Message-ID: <43062E37.4000105@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com> <4304DBA1.4050900@pobox.com> <20050819140631.GB12485@lst.de> <43061C3C.2020303@adaptec.com> <20050819175459.GA16619@lst.de> <43061D57.9060201@adaptec.com> <20050819175929.GA5614@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:59081 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S965016AbVHSTIq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 15:08:46 -0400
In-Reply-To: <20050819175929.GA5614@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James.Smart@Emulex.Com, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On 08/19/05 13:59, Christoph Hellwig wrote:
> On Fri, Aug 19, 2005 at 01:56:39PM -0400, Luben Tuikov wrote:
> 
>>>Yes.  But to get that to work we'll need to fix some assumptions in
>>>libata, define proper interfaces between the SAS LLDD, the SAS transport
>>>class and libata.  It's doable and desirable, but it'll need some work.
>>
>>Do you have a SAS LLDD?
> 
> 
> See the mptsas driver I posted today.

Sorry, this is _not_ a SAS LLDD.  There is *nothing*, I repeat
*nothing* SAS in that code.

	Luben
 
>>Which one is it that will let you do this?
> 
> 
> Currently none.  Fusion is doing the SATA command translation in firmware.
> This is more for Adapters in the style of the Adaptec design where it
> would be done in the host software stack.
> 

