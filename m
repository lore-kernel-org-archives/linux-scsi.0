From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [RFC] SCSI Hotplug for lk 2.5
Date: Tue, 6 Aug 2002 21:21:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0208062119370.70666-100000@beppo>
References: <20020806154309.A13999@eng2.beaverton.ibm.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020806154309.A13999@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: "Cress, Andrew R" <andrew.r.cress@intel.com>, Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

> I'm not very familiar with SAF-TE or the software raid tools.
> 
> Your program polls a special interface to the SAF-TE to figure out
> what LUNs (or targets) are attached, and if a new LUN or target shows
> up, you scan it? Does mdadm do the scan for you? 
> 
> Does it always generate a bus reset when a device is added or removed?

Nope. SAF-TE is similar to SES. It's a SCSI protocol that you use to
identify components and status in enclosures. One of these objects
are 'disk slots' showing presence/absence.


