From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aic7xxx strange code
Date: Thu, 01 Jan 2004 09:16:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <478922704.1072973783@aslan.scsiguy.com>
References: <1072885576.10877.6.camel@laptop.fenrus.com> <960352704.1072895786@aslan.btc.adaptec.com>
 <20040101100809.GA1053@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.scsiguy.com ([63.229.232.106]:22532 "EHLO
	aslan.scsiguy.com") by vger.kernel.org with ESMTP id S264429AbUAAQQ0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jan 2004 11:16:26 -0500
In-Reply-To: <20040101100809.GA1053@devserv.devel.redhat.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: linux-scsi@vger.kernel.org

>> I'm more than happy to change the #ifdefs on the hack to exclude 2.6
>> so long as all platforms the driver operates under behave as expected.
>> If 2.4 is any guide, however, there may still be some bogus code lurking
>> around that uses the "normal" dma mask incorrectly.
> 
> Those platforms break the API and should be fixed as opposed to hacks added
> to every single driver in drivers/*

Unfortunately, fixing 2.4 and 2.6 now doesn't help in supporting older
kernels that are still in production.  You can't change the past no
matter how hard we'd like to try. 8-)

--
Justin

