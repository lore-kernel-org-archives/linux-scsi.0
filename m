From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 1/2] allow user to power off unused ports via sysfs
Date: Fri, 04 Jul 2008 08:58:12 -0400
Message-ID: <486E1E64.6090506@garzik.org>
References: <20080702225743.518230210@intel.com> <20080702161401.0fac6613@appleyard>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080702161401.0fac6613@appleyard>
Sender: linux-ide-owner@vger.kernel.org
To: kristen.c.accardi@intel.com
Cc: linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

kristen.c.accardi@intel.com wrote:
> This patch expands the definition of link power management to 
> include the notion of simply powering the entire port off.  
> We add a new valid value for link_power_management_policy:
> 
> power_off:  phy is not on at all.
> min_power:  driver uses minimum possible power. hotplug
>             may or may not be available.
> medium_power: best power/performance tradeoff.  hotplug
>             may or may not be available
> max_performance: max performance without regard to power
>             hot plug is available.
> 
> Additionally - this patch modifies the libata-core to
> power off the port automatically at init time if the
> driver marks the port as not hotpluggable.
> 
> The user may not power off a port if it is occupied.
> If the port is powered off, and a new drive is plugged
> in, the drive will not be detected until the port is
> powered back up by setting the link_power_management_policy
> to "max_performance".
> 
> Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> ---
>  drivers/ata/libata-core.c |   58 +++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/ata/libata-scsi.c |    1 
>  include/linux/libata.h    |    2 +
>  3 files changed, 60 insertions(+), 1 deletion(-)

Looks good to me, ACK.

I'm apply soonish, unless there are other complaints.


