From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aic7xxx woes in 2.5
Date: Sun, 15 Dec 2002 13:17:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <28320000.1039983464@aslan.btc.adaptec.com>
References: <3DFC059A.9AA3F75F@digeo.com> <3DFC1BD2.F2F347C9@yk.rim.or.jp>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DFC1BD2.F2F347C9@yk.rim.or.jp>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Ishikawa <ishikawa@yk.rim.or.jp>, Andrew Morton <akpm@digeo.com>
Cc: linux-scsi@vger.kernel.org

> Hi,
> 
>> The parity error is intermittent.  But when it happens, the lockup
>> always happens.
>> 
>> This never happens in 2.4 kernels.
>> 
>> It seems to happen a little more frequently on uniprocessor builds.
>> 
>> So relevant questions would be:
>> 
>> 1) Why does only 2.5 get the parity error?
> 
> 
> Since you say "uniprocessor builds", maybe you are using 
> high-quality dual processor board. But just in case, does your
> motherboard support proper PCI parity bus check?

These are SCSI parity errors, not PCI parity errors.

--
Justin
