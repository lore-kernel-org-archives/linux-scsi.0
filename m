From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v6 0/7] ZPODD patches
Date: Thu, 13 Sep 2012 11:20:23 +0800
Message-ID: <505150F7.3040800@intel.com>
References: <1346768680-7287-1-git-send-email-aaron.lwe@gmail.com> <7AD76063A97F48128F7F6B285CD05C7E@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <7AD76063A97F48128F7F6B285CD05C7E@usish.com.cn>
Sender: linux-ide-owner@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: 'Aaron Lu' <aaron.lwe@gmail.com>, 'Alan Stern' <stern@rowland.harvard.edu>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>, 'Jeff Garzik' <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/13/2012 10:42 AM, Jack Wang wrote:
> Hi Aaron,

Hi Jack,

> 
> This feature looks nice

Glad to hear this :-)

> but how could I test this patch set, I suppose it
> need special Hardware which support ZPODD, could suggest the test setup
> environment?

For ZPODD, there are 2 requirements:
1 The platform, it has to have the ability to power off a sata device
while at S0;
2 The ODD needs support for device attention capability.

> 
> For hard disk runtime power off, Is there (hardware?) requirement for hard
> drive to support similar feature?

No requirement for hard drive, as it does not need to remote wake up
itself while powered off.

Please note that there is a v7 sent yesterday, you may want to take a
look at that instead of v6.

And the runtime power off of hard drive is dropped from that patch set,
I'll submit it in another patch set(pretty small changes needed).

Thanks,
Aaron
