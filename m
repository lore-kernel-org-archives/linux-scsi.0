From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: GRUB doesn't like ServeRAID M1015/LSI 9220-8i (was Re: mvsas
 with 3.1)
Date: Thu, 02 Feb 2012 11:02:10 +0800
Message-ID: <4F29FCB2.6040204@fnarfbargle.com>
References: <201201131144.58044.thomas@fjellstrom.ca> <201202010703.09833.thomas@fjellstrom.ca> <4F294E64.10204@anonymous.org.uk> <201202010742.07818.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201202010742.07818.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/02/12 22:42, Thomas Fjellstrom wrote:
>
> Yeah, GRUB immediately throws an "out of memory. Aborted" error, its annoying,
> but I reported the issue on GRUB's bug tracker after talking to a guy in #grub
> on freenode. Hopefully someone looks at it soon. It appears it happens so
> early in grub's startup that it can't even output any debug info (I was asked
> to run: `grub-install --debug-image=all /dev/sdX`, and did so, I get debug
> output when the card is not installed, but absolutely nothing when it is
> installed.

Just another data point. I've seen this issue also. It does not appear to be GRUB's fault. It 
appears the BIOS on the card does something funky as it also prevents syslinux/isolinux/pxelinux and 
its friends from properly detecting/reporting the machines memory. Machine has 16GB but a PXE boot 
believes it has 3GB.

I "worked around" the problem by swapping out the mainboard for a later model with a different BIOS 
and the problem went away. Not pretty, but it was the only way I could get the machine to boot with 
those cards in it. I have 4 IBM cards in 2 machines and they work fine here. I still have the dodgy 
mainboard and can set it up if you need help testing/reproducing the issue.

Regards,
Brad
