From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFTesters] Re: [PATCH] refactor tmscsim inititalization code
Date: Tue, 21 Sep 2004 07:41:37 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409210739070.2436@poirot.grange>
References: <20040904130235.GA20552@lst.de> <Pine.LNX.4.60.0409071040120.2966@poirot.grange>
 <20040910133254.GB32530@lst.de> <Pine.LNX.4.60.0409172052230.31193@poirot.grange>
 <20040920152450.GA27419@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:49887 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267287AbUIUFmS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 01:42:18 -0400
In-Reply-To: <20040920152450.GA27419@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Kurt Garloff <garloff@suse.de>

On Mon, 20 Sep 2004, Christoph Hellwig wrote:

>> Ok, now, that the patch has been applied, and, as Christoph informed me,
>> it would be difficult (impossible?) to undo it, we have to fix it. I'll
>> explain my doubts separately as a reply to another Christoph's email. Or
>> would it still be possible to get a patch in, reverting the EEPROM rework?
>
> might be best to just revert it, I'll cook up a patch.

And one more thought - would be good to add comments to now inlined code 
to explain explicitly what previously function names were hinting at. But 
this can be a follow-up patch. The only problem - I don't quite understand 
what all EEPROM function names meant. Kurt?

Thanks
Guennadi
---
Guennadi Liakhovetski

