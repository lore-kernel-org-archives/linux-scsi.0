From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [RFC][PATCH 2.6.11-rc2] Linux SCSI hotplug infrastructure
Date: Mon, 7 Feb 2005 13:40:38 -0600
Message-ID: <20050207194038.GA19320@lists.us.dell.com>
References: <20050207182753.GA16526@lists.us.dell.com> <4207BFF5.4000404@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4207BFF5.4000404@us.ibm.com>
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 07, 2005 at 01:22:29PM -0600, Brian King wrote:
> Just curious why the following flow would not work/be preferred:
> 
> 1. echo "2" > /sys/class/scsi_host/host2/logical_drive_created
> 2. megaraid_mbox.c sysfs method converts logical drive number to HCTL 
> value, calls scsi_add_device.
> 3. scsi_add_device works as it does today and generates hotplug events
> 
> -Brian


This direction was what came out of this thread back in December.
http://marc.theaimsgroup.com/?l=linux-kernel&m=110314267629902&w=2

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com


-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now.
http://ads.osdn.com/?ad_id=6595&alloc_id=14396&op=click
