From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: PROBLEM: SYM53C8XX errors while reading tape
Date: Sat, 23 Nov 2002 12:57:43 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0211231231290.26253-100000@filesrv1.baby-dragons.com>
References: <86k7j43gh7.fsf@coulee.tdb.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <86k7j43gh7.fsf@coulee.tdb.com>
List-Id: linux-scsi@vger.kernel.org
To: Russell Senior <seniorr@aracnet.com>
Cc: Linux Scsi maillist <linux-scsi@vger.kernel.org>


	Hello Russell ,  Sorry about taking the original reply off list
	I should know better .  According to the dmesg & the log dumps
	you sent you were (were they edited?) .  Please make sure that
	SYM53C8XX_2 driver was the only driver in the 53c8* series that
	was selected or That modules were not being selected anyway .

	I for one KNOW that if the SYM53C8XX driver is compiled in OR
	listed first in the module.conf file IT will be loaded in front of
	the SYM53C8XX_2 and this will keep the sym2 from loading at all .
	And I have seen (at least three times) a condition where the
	SYM53C8XX_2 WAS compiled IN (just like you) and the SYM53C8XX was
	a module and it was -still- loaded & began conflicting with the
	SYM53C8XX_2 during use .  Hth ,  JimL

ps:	On my systems I have had at onetime or another almost every
	(older) scsi tape drive manufactured .  And damn near everytime I
	have had a problem it has been some mistake on my end .  A bus a
	tad to long ,  the terminator I bought was just a little to good
	to beleive price wise ...

On 22 Nov 2002, Russell Senior wrote:

> >>>>> "James" == James W Laferriere <babydr@baby-dragons.com> writes:
>
> James> 	Hello Russell , Could you try the SYM53C8XX_2 driver ?  I
> James> beleive that this may help .  JimL
>
> I _was_ using the SYM53C8XX_2 driver.  Here's the relevant portion of
> my .config for 2.4.18:
>
>   # CONFIG_SCSI_NCR53C7xx is not set
>   CONFIG_SCSI_SYM53C8XX_2=y
>   CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
>   CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
>   CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
>   # CONFIG_SCSI_SYM53C8XX_IOMAPPED is not set

--
       +------------------------------------------------------------------+
       | James   W.   Laferriere | System    Techniques | Give me VMS     |
       | Network        Engineer |     P.O. Box 854     |  Give me Linux  |
       | babydr@baby-dragons.com | Coudersport PA 16915 |   only  on  AXP |
       +------------------------------------------------------------------+


