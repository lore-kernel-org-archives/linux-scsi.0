From: vinayak holikatti <vinholikatti@gmail.com>
Subject: Re: [PATCH V2 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
Date: Thu, 19 Jul 2012 16:59:26 +0530
Message-ID: <CAKVbJB8HF2EdLxaEL7PMcU5ZAM70TCA0Y-AbDRz4g_TuXSRgBw@mail.gmail.com>
References: <1342188465-20239-1-git-send-email-vinholikatti@gmail.com>
	<201207131545.28877.arnd@arndb.de>
	<1342447217.3176.22.camel@dabdike.int.hansenpartnership.com>
	<201207161622.24063.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <201207161622.24063.arnd@arndb.de>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, sreekumar.c@samsung.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 16, 2012 at 9:52 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 16 July 2012, James Bottomley wrote:
>> On Fri, 2012-07-13 at 15:45 +0000, Arnd Bergmann wrote:
>> > On Friday 13 July 2012, Vinayak Holikatti wrote:
>> > > This patch set adds following features
>> > >  - Seprates PCI specific code from ufshcd.c to make it as core
>> > >  - Adds PCI glue driver ufshcd-pci.c
>> > >  - Adds Platform glue driver ufshcd-pltfrm.c
>> > >  - Update correct transfer size in Command UPIU
>> >
>> > Acked-by: Arnd Bergmann <arnd@arndb.de>
>>
>> I need a maintainer ack for this to go upstream.
>>
>> Also, looking at this, I think this patch series isn't bisectable:
>> Patch 1 removes PCI support and patch 2 adds it back in a different
>> form.  However, any PCI based UFS system would stop working if the
>> bisect landed at patch 1.  I think you can fix this just by combining
>> patches 1 and 2.
>
> I suggested to split the patch in two in a private review that we
> did on the linaro mailing list. I gave my Ack because the split
> was done, but I failed to notice that it was done differently
> from what I suggested in
>
> On Monday 02 July 2012, Arnd Bergmann wrote:
>> I would recommend that you split this patch into two separate
>> changesets, where you do all the changes to existing code in the
>> first patch, and only move but don't change code in the second one
>> that creates the new file.
>
> I agree that breaking bisectibility by ripping out the PCI code
> first is not good. The version 2 is not actually easier to review
> at all than the first version, it just splits the changes by
> file, which is pointless.
I will roll out another patch series which will address the current issue.
Firstly will modify existing code with PCI code and then in the second
move the code to new file ufshcd-pci.c
>
>         Arnd
>
