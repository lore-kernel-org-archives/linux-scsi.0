From: vinayak holikatti <vinholikatti@gmail.com>
Subject: Re: [PATCH 3/4] [SCSI] ufs: Add AMBA glue driver to ufshcd
Date: Wed, 11 Jul 2012 09:50:43 +0530
Message-ID: <CAKVbJB-sxxU4opKWKZk8X3WS=nd_EvoxUPpvg4+AXhaQZkLk1A@mail.gmail.com>
References: <1341239572-7408-1-git-send-email-vinholikatti@gmail.com>
	<1341239572-7408-4-git-send-email-vinholikatti@gmail.com>
	<201207021520.03774.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <201207021520.03774.arnd@arndb.de>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, yejin.moon@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, stephen.doel@linaro.org, sreekumar.c@samsung.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 2, 2012 at 8:50 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 02 July 2012, Vinayak Holikatti wrote:
>> +static struct amba_id ufshcd_amba_ids[] = {
>> +       {
>> +               /* Fake id for Primecell.*/
>> +               .id     = 0x00041FF0,
>> +               .mask   = 0x000fffff,
>> +       },
>> +       { 0, 0 },
>> +};
>
> Hi Vinayak,
>
> Can you explain where this fake ID comes from? Is this ID actually
> used by any hardware that is around somewhere? If not, I think it
> would be better not to provide an AMBA driver at all, but instead
> use the platform driver from patch 2 for all non-PCI uses.
The fake ID is just a dummy ID. As you say, we will drop the amba driver
for now. When primecell controller comes up, we will have the driver integrated.
>
>         Arnd
