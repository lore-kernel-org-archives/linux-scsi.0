From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Fri, 28 Mar 2003 22:30:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030329063045.GA1709@beaverton.ibm.com>
References: <20030325100704.GC3868@beaverton.ibm.com> <1048613872.2070.12.camel@mulgrave> <20030325184530.GA1202@beaverton.ibm.com> <1048618939.1790.29.camel@mulgrave> <20030325232920.GB2692@beaverton.ibm.com> <1048779761.1789.21.camel@mulgrave> <20030328173253.A32352@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030328173253.A32352@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Matthew Dharm [mdharm-scsi@one-eyed-alien.net] wrote:
> Well, Linus wants this to work for usb-storage more short-term than
> long-term....
> 
> Suggestions?
> 

I am still working toward the goal of supporting this. Short-term /
long-term will be determined by the changes and Linus / James's
recommendation. I will wait to see the iterator that Mochel recommends.
In the mean time I am working on getting our scsi_host sysfs structure
corrected so that release can be called at the proper time.

-andmike
--
Michael Anderson
andmike@us.ibm.com

