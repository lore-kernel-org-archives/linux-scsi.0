From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [BUG] 2.6.25-rc2-git3 broke cdrecord
Date: Mon, 03 Mar 2008 22:41:33 +0100
Message-ID: <47CC708D.9020504@s5r6.in-berlin.de>
References: <20080302233415.GA6258@Pilar>	 <18379.18297.838050.536473@harpo.it.uu.se>	 <tkrat.468fd04c47ae1a2a@s5r6.in-berlin.de>	 <20080303172641Z.fujita.tomonori@lab.ntt.co.jp>	 <47CBC014.9090309@s5r6.in-berlin.de>	 <47CC37CA.1040407@s5r6.in-berlin.de> <9ea470500803031000o223e7cbcl160ce776c54db1a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <9ea470500803031000o223e7cbcl160ce776c54db1a9@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: petkovbb@gmail.com
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mikpe@it.uu.se, crmafra2@gmail.com, linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com, htejun@gmail.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Boris Petkov wrote:
>>  >> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>>  >>> CD burning still fails for me via ide-cd,
...
> we have fixed a similar bug to yours and the patch went in after
> 2.6.25-rc3 - more specifically
> bcd88ac3b2ff2eae3d0fa57a6b02d4fce5392f32 - so please test current git head wrt
> burning with ide-cd.

I tested 2.6.25-rc3-git4 now, plus Tomo's block layer patch.
Burning with wodim over ide-cd works now.  Thanks everybody,
-- 
Stefan Richter
-=====-==--- --== ---==
http://arcgraph.de/sr/
