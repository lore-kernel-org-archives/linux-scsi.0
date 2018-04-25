From: Paul Menzel <pmenzel+linux-block@molgen.mpg.de>
Subject: Re: Regression 4.17-rc1: SSD doesn properly resume causing system
 hang (NULL pointer dereference)
Date: Wed, 25 Apr 2018 07:37:55 +0200
Message-ID: <d5e8823e-27bd-dabe-174f-b111a48b440a@molgen.mpg.de>
References: <59ca6556-11a6-4f77-76e7-d51c7175eb32@molgen.mpg.de>
 <67ffdf0050a04bf3615c3d8a3a90b0c9c2aeb1ad.camel@wdc.com>
 <2cc5f0fb-4caa-9c28-7daa-68993d5cb41a@molgen.mpg.de>
 <14ff1ed06e36a372680872c227b5abe389c753da.camel@wdc.com>
 <a3a7f906-3681-15cc-67af-b96e4ac71b0e@molgen.mpg.de>
 <134955874b401e6764077393c75ab2d4549b940a.camel@wdc.com>
 <6a2162a7-5f48-c107-0b1c-5258089522c5@molgen.mpg.de>
 <19e19bc6b2fef11faf428fe75447b06e56af9ffd.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <19e19bc6b2fef11faf428fe75447b06e56af9ffd.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: jejb@linux.vnet.ibm.com, regressions@leemhuis.info, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, martin.petersen@oracle.com, axboe@kernel.dk, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Dear Bart,


Am 24.04.2018 um 23:17 schrieb Bart Van Assche:
> On Tue, 2018-04-24 at 23:04 +0200, Paul Menzel wrote:
>> I applied your change, and rebuilt the Linux kernel. Unfortunately, it
>> looks like, it didn’t make a difference.
> 
> In that case I don't know what is causing the failure. Can you run a bisect
> to determine which commit introduced this regression?

With `scsi_mod.use_blk_mq=n` the system resumes fine, so for to me 
unknown reasons, that Kconfig option get selected in my Linux kernel 
configuration. I remember having similar issues when this was enabled by 
default in Linux 4.13-rc?, so it was just a configuration problem and 
not a regression. Unfortunately, the Linux configuration files are not 
under version control, so I cannot check, but it is probably my fault.

Sorry for the noise, and please tell me, what I can do to get the option 
working on this old device.


Kind regards,

Paul
