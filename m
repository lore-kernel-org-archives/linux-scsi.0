From: "K.R. Foley" <kr@cybsft.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Thu, 26 May 2005 05:37:48 -0500
Message-ID: <4295A6FC.9000509@cybsft.com>
References: <20050516085832.GA9558@gmail.com>	<20050517071307.GA4794@in.ibm.com>	<20050517002908.005a9ba7.akpm@osdl.org>	<20050517083436.GB4794@in.ibm.com> <20050526003930.71bb14fb.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02.pair.com ([209.68.5.16]:51474 "HELO relay02.pair.com")
	by vger.kernel.org with SMTP id S261279AbVEZKhu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2005 06:37:50 -0400
In-Reply-To: <20050526003930.71bb14fb.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: dino@in.ibm.com, gregoire.favre@gmail.com, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> Dinakar Guniguntala <dino@in.ibm.com> wrote:
> 
>>On Tue, May 17, 2005 at 12:29:08AM -0700, Andrew Morton wrote:
>>
>>>Better cc linux-scsi.
>>
>>  Thanks
>>
>>
>>>Are these bugs also present in 2.6.12-rc4?
>>
>>Yes, I tried a vanilla 2.6.12-rc4 and I get the same output.
>>I get this from 2.6.12-rc3 onwards. 
> 
> 
> Gents, can you please confirm that 2.6.12-rc5 is working OK now?
> 

Andrew,

I know this wasn't directed at me, but I can confirm that the problems I
was having with my aic7899, that James and I resolved under this thread,
are in fact gone in 2.6.12-rc5. Booted it last night. :-)

-- 
   kr
