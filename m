From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH] scsi: Check if the device support WRITE_SAME_10
Date: Wed, 12 Jun 2013 21:34:36 +0200
Message-ID: <51B8CD4C.8060304@itwm.fraunhofer.de>
References: <51AC1440.7020505@zytor.com> <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com> <51AC3283.4000403@zytor.com> <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com> <51ACBAA0.40604@zytor.com> <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com> <51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net> <51AD2485.9000601@zytor.com> <alpine.DEB.2.02.1306041132260.19072@jlaw-desktop.mno.stratus.com> <51AF0CCF.8000909@itwm.fraunhofer.de> <51AF232C.8060209@itwm.fraunhofer.de> <51AF34E0.3030609@itwm.fraunhofer.de> <yq1r4ggpdy7.fsf@sermon.lab.mkp.net> <51AF9AF2.5000907@itwm.fraunhofer.de> <yq1fvwuoeck.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1fvwuoeck.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "H. Peter Anvin" <hpa@zytor.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 06/07/2013 04:15 AM, Martin K. Petersen wrote:
>>>>>> "Bernd" == Bernd Schubert <bernd.schubert@itwm.fraunhofer.de> writes:
>
>>> max_t(unsigned long, max, SD_MAX_WS10_BLOCKS);
>
> Bernd> Max? Not min_t()?
>
> Brain fart. Updated patch with a few other adjustments.
>
> I have tested this on a couple of JBODs with a mishmash of SATA and SAS
> drives, including a few specimens that report MAX WRITE SAME BLOCKS.
>

Thanks for the update!

I'm far too long at work again, but I managed to test it now and it 
works fine for the ancient areca controller (ARC-1260) of this test-lab. 
So you may add

Tested-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

and

Reviewed-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

(although the latter probably does not count much for linux-scsi).


Cheers,
Bernd
