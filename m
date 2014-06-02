From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [ANNOUNCE] scsi patch queue tree
Date: Mon, 02 Jun 2014 11:25:00 +0300
Message-ID: <538C34DC.3080103@gmail.com>
References: <20140519140614.GA12183@infradead.org> <20140520100343.31490551@canb.auug.org.au> <20140520053928.GA1751@infradead.org> <20140521094636.515289e8@canb.auug.org.au> <1400639101.2481.19.camel@dabdike> <20140528105429.GA20549@infradead.org> <20140602075812.GA29632@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:49239 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaFBIZE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 04:25:04 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so4736396wgg.30
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jun 2014 01:25:02 -0700 (PDT)
In-Reply-To: <20140602075812.GA29632@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On 06/02/2014 10:58 AM, Christoph Hellwig wrote:
> With Linus opening the merge window things should calm down now.
> 
> I've pushed the mvsas pciid update, and a revert of the be2scsi patch
> that wasn't quite ready to the drivers-for-3.16 branch.
> 
> I've also created a new drivers-for-3.16-2 branch that contains the
> remaining hpsa updates that might be too big for Linus taste that late
> but should probably be fine.  I also expect to add the relatively small
> lpfc update to it once I get second review in proper form.
> 

Hi Christoph

Could you please add this very trivial patch for this merge window?
http://www.spinics.net/lists/linux-scsi/msg74774.html

my hack here: http://www.spinics.net/lists/linux-scsi/msg74775.html

Forgot to CC you sorry
Thanks
Boaz

