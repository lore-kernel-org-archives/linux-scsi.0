From: Zwane Mwaikambo <zwane@holomorphy.com>
Subject: Re: [PATCH][2.5] SCSI hosts.c missing device_register
Date: Sat, 23 Nov 2002 15:09:11 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.50.0211231508220.1462-100000@montezuma.mastecende.com>
References: <200211232000.gANK00903642@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200211232000.gANK00903642@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 23 Nov 2002, J.E.J. Bottomley wrote:

> It looks like you're getting an error between scsi_register and scsi_add_host
> that's causing the HBA to bail and something to think it needs to deregister a
> curently unregistered host_driverfs_dev.
>
> Most likely, the problem is in the HBA driver.  Which host adapter is this?

aha1542.c without the device physically installed. I presume the ->detect
function failed.

-- 
function.linuxpower.ca
