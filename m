From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aic7xxx strange code
Date: Thu, 01 Jan 2004 09:21:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <482322704.1072974098@aslan.scsiguy.com>
References: <1072885576.10877.6.camel@laptop.fenrus.com> <960352704.1072895786@aslan.btc.adaptec.com>
 <20040101100809.GA1053@devserv.devel.redhat.com> <478922704.1072973783@aslan.scsiguy.com>
 <20040101161731.GB18742@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.scsiguy.com ([63.229.232.106]:26628 "EHLO
	aslan.scsiguy.com") by vger.kernel.org with ESMTP id S264509AbUAAQVk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jan 2004 11:21:40 -0500
In-Reply-To: <20040101161731.GB18742@devserv.devel.redhat.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: linux-scsi@vger.kernel.org

>> Unfortunately, fixing 2.4 and 2.6 now doesn't help in supporting older
>> kernels that are still in production.  You can't change the past no
>> matter how hard we'd like to try. 
> 
> But vendors will update those kernels.....

Yes, but I can't remove support for these older kernels for quite
some time.  So, I'd be more than happy to update the comments explaining
why the code is there and change the #ifdefs to further limit its use,
but the code needs to remain for the time being.

Are you planning an audit of the other platforms to ensure API compliance?

--
Justin

