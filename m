From: Go Taniguchi <go@turbolinux.co.jp>
Subject: Re: 2.6.6-rc2-mm2 + Adaptec I2O
Date: Tue, 27 Apr 2004 20:53:29 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <408E49B9.3090302@turbolinux.co.jp>
References: <408DE95F.5010201@tequila.co.jp>	<20040426221814.490a0cfd.akpm@osdl.org>	<Pine.LNX.4.58.0404262223260.17702@dlang.diginsite.com>	<408DF117.4060309@tequila.co.jp>	<20040426230455.53406d74.akpm@osdl.org>	<408DFBEE.3080803@tequila.co.jp> <20040426232522.253594a2.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.turbolinux.co.jp ([210.171.55.67]:37892 "EHLO
	mail.turbolinux.co.jp") by vger.kernel.org with ESMTP
	id S264022AbUD0Lxw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 07:53:52 -0400
In-Reply-To: <20040426232522.253594a2.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org
Cc: Clemens Schwaighofer <cs@tequila.co.jp>, dlang@digitalinsight.com, linux-kernel@vger.kernel.org

Hi,

Andrew Morton wrote:
> Clemens Schwaighofer <cs@tequila.co.jp> wrote:
> 
>>Andrew Morton wrote:
>> | Clemens Schwaighofer <cs@tequila.co.jp> wrote:
>> |
>> |> on this URL [http://www.smartcgi.com/?action=docs,kernel26-adaptec] you
>> |> can find a patch that I could successfully path again 2.6.5 (vanilla)
>> |> and compile successfully.
>> |
>> |
>> | hm.  Against 2.6.0.  Go, would you have time to send that patch in to the
>> | scsi team at linux-scsi@vger.kernel.org?
>>
>> yes,
>>
>> remark:
>>
>> ~ Originally this patch has been released by Go Taniguchi at
>> http://pkgcvs.turbolinux.co.jp/~go/patch-2.6/dpt_i2o.patch
>>
>> patch attached
> 
> 
> Sorry, my question was directed to Go Taniguchi <go@turbolinux.co.jp> - Go
> should submit the patch.

Yea, I sent an mail to LKML in the end of last year regarding this issue.
http://marc.theaimsgroup.com/?l=linux-kernel&m=107275564119915&w=2

However, I think that Adaptec probably just re-make a new version of dpt_i2o.
My patch may differ from the Adaptec policy.

I thought that it may be good for someone need the driver before Adaptec 
completed the driver. What's why I uploaded my patch onto web.

The number of the access is over 1000 now after I counted it.

Please merge to Andrew's tree if Adaptec does not mind.

This is my patch same as send from Clemens.
http://pkgcvs.turbolinux.co.jp/~go/patch-2.6/dpt_i2o.patch


